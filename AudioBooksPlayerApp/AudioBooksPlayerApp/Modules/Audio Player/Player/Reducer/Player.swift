//
//  Player.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import ComposableArchitecture

struct Player {
    // MARK: - Dependency
    
    @Dependency(\.storeService) var storeService
    @Dependency(\.audiobookService) var audiobookService
    @Dependency(\.player) var player
    
    // MARK: - Private Func
    
    private func reduce(into state: inout State, 
                        controlsAction: PlayerActionButtonsReducer.Action) -> Effect<Action> {
        switch controlsAction {
        case .nextTapped:
            if state.currentChapterIndex < state.chapters.count {
                state.currentChapterIndex += 1
                
                return .run { send in
                    await send(.chapterChanged)
                }
            }
            
            return .none

        case .previousTapped:
            state.currentChapterIndex -= 1

            return .run { send in
                await send(.chapterChanged)
            }

        case .playTapped:
            let playerState = state.controls.playerState
            guard playerState.isEnabled else { return .none }
            state.controls.playerState = playerState.isPlaying ? .paused : .playing

            return .run { [rate = state.playbackRate] _ in
                if playerState.isPlaying {
                    await player.pause()
                } else {
                    await player.play(rate)
                }
            }

        case .seekBackTapped:
            return .run { _ in
                await player.seekBackwardBy(Constants.Progress.seekBackwardInterval)
            }

        case .seekForwardTapped:
            return .run { _ in
                await player.seekForwardBy(Constants.Progress.seekForwardInterval)
            }
        }
    }

    private func reduce(into _: inout State, 
                        progressAction: SliderReducer.Action) -> Effect<Action> {
        switch progressAction {
        case let .sliderUpdated(progress):
            return .run { _ in
                await player.seekTo(progress)
            }
        }
    }

    private func reduce(into state: inout State, 
                        modeAction: ModeSelectorReducer.Action) -> Effect<Action> {
        switch modeAction {
        case .selectorTaped:
            state.alert = .init(title: "On development 😎",
                                content: Constants.Alert.modeUnavailable,
                                buttonTitle: "Ok",
                                actionOnTap: .modeAlertDismissed
            )
        }

        return .none
    }

    private func loadAudiobook() -> Effect<Action> {
        .run { send in
            await send(
                .audiobookLoaded(
                    TaskResult { try await audiobookService.audiobook() }
                )
            )
        }
    }

    private func loadCurrentChapter(for state: inout State) -> Effect<Action> {
        guard let chapterUrl = state.chapters[state.currentChapterIndex].audioURL
        else {
            return .none
        }

        return .run { send in
            await player.pause()

            await send(
                .chapterLoaded(
                    TaskResult { try await player.itemAt(chapterUrl) }
                )
            )
        }
    }

    private func nextPlaybackRate(for currentRate: Float) -> Float {
        if currentRate < Constants.Rate.max {
            return currentRate + Constants.Rate.step
        } else {
            return Constants.Rate.min
        }
    }
}

// MARK: - Extension Player+Reducer

extension Player: Reducer {
    
    var body: some ReducerOf<Self> {
        Scope(state: \.progress, action: /Action.progress) {
            SliderReducer()
        }

        Scope(state: \.controls, action: /Action.controls) {
            PlayerActionButtonsReducer()
        }

        Scope(state: \.mode, action: /Action.mode) {
            ModeSelectorReducer()
        }

        Reduce { state, action in
            switch action {
            case .viewAppeared:
                state.isPremium = storeService.hasPro

                if !state.isPremium {
                    state.alert = .init(title: "Unlock learning",
                                        content: "Grow on the go by listening and reading the world's best ideas",
                                        buttonTitle: "Start Listening • $89,99",
                                        actionOnTap: .buyPremiumTapped
                    )
                }
                return loadAudiobook()
                
            case .buyPremiumTapped:
                return .run { send in
                    do {
                        let _ = try await storeService.purchase()
                        await send(.purchased)
                    } catch {
                        await send(.purchaseError)
                    }
                }
                
            case .purchased:
                state.alert = nil
                state.isPremium = storeService.hasPro
                return .none
                
            case .purchaseError:
                state.alert = .init(title: "Oops",
                                    content: "Your purchase failed. Please try again or write to support",
                                    buttonTitle: "Retry",
                                    actionOnTap: .buyPremiumTapped)
                return .none

            case let .audiobookLoaded(.success(audiobook)):
                state.imageURL = audiobook.imageURL
                state.chapters = audiobook.chapters

                return loadCurrentChapter(for: &state)

            case .audiobookLoaded(.failure):
                
                state.alert = .init(title: "Oops",
                                    content: Constants.Alert.bookLoadingFailed,
                                    buttonTitle: "Retry",
                                    actionOnTap: .retryAudiobookLoadingTapped
                )

                return .none

            case let .chapterLoaded(.success(time)):
                state.progress.status = .enabled(.init(time: time,
                                                       step: Constants.Progress.step))
                state.controls.playerState = .paused
                state.controls.hasNextChapter = state.hasNextChapter
                state.controls.hasPreviousChapter = state.hasPreviousChapter

                return .run { send in
                    for await progress in await player.progress() {
                        await send(.playbackProgressUpdated(progress))
                    }
                }

            case .chapterLoaded(.failure):
                state.progress.status = .disabled
                state.controls.playerState = .disabled
                state.controls.hasNextChapter = state.hasNextChapter
                state.controls.hasPreviousChapter = state.hasPreviousChapter
                
                state.alert = .init(title: "Oops",
                                    content: Constants.Alert.chapterLoadingFailed,
                                    buttonTitle: "Retry",
                                    actionOnTap: .retryChapterLoadingTapped
                )
                
                return .none

            case .chapterChanged:
                state.controls.playerState = .disabled
                state.progress.status = .disabled
                return loadCurrentChapter(for: &state)

            case let .playbackProgressUpdated(progress):
                switch progress {
                case let .value(progress):
                    state.progress.current = progress
                    return .none

                case .ended:
                    state.progress.current = .zero
                    state.controls.playerState = .paused
                    return loadCurrentChapter(for: &state)
                }

            case .rateButtonTapped:
                state.playbackRate = nextPlaybackRate(for: state.playbackRate)
                guard state.controls.playerState.isPlaying else { return .none }

                return .run { [rate = state.playbackRate] _ in
                    await player.changeSpeed(rate)
                }

            case .alertDismissed:
                state.alert = nil
                return .none

            case .modeAlertDismissed:
                state.alert = nil
                state.mode.mode = .audio
                return .none

            case .retryChapterLoadingTapped:
                state.alert = nil
                return loadCurrentChapter(for: &state)

            case .retryAudiobookLoadingTapped:
                state.alert = nil
                return loadAudiobook()

            case let .progress(action):
                return reduce(into: &state, progressAction: action)

            case let .controls(action):
                return reduce(into: &state, controlsAction: action)

            case let .mode(action):
                return reduce(into: &state, modeAction: action)
            }
        }
    }
}
