//
//  PlayerReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import Foundation
import UIKit.UIImage

extension Player {
    enum Constants {
        enum Rate {
            static let max: Float = 2.0
            static let min: Float = 0.25
            static let step: Float = 0.25
            static let standart: Float = 1.0
        }

        enum Progress {
            static let step: Double = 1.0
            static let seekForwardInterval: Double = 10.0
            static let seekBackwardInterval: Double = 5.0
        }

        enum Alert {
            static let bookLoadingFailed: String = "Audiobook loading failed ☹️"
            static let chapterLoadingFailed: String = "Sorry, chapter audio loading failed ☹️"
            static let chapterAudioUnavailable: String = "Sorry, the audio for this chaptes is unavailable ☹️"
            static let modeUnavailable: String = "Sorry, this feature is not implemented yet ☹️"
            static let dismiss: String = "OK"
            static let retry: String = "Retry"
        }

        static let defaultChapterIndex: Int = 0
    }
}

extension Player {
    struct State: Equatable {
        var isPremium: Bool = false
        
        var imageURL: URL?
        var chapters: [Chapter] = []
        var currentChapterIndex: Int = Constants.defaultChapterIndex
        var playbackRate: Float = Constants.Rate.standart

        var progress: SliderReducer.State = .init()
        var controls: PlayerActionButtonsReducer.State = .init()
        var mode: ModeSelectorReducer.State = .init()

        var alert: AlertState<Action>?

        var chaptersCountTitle: String {
            guard !chapters.isEmpty else { return "No keypoints available" }
            return "Key point \(currentChapterIndex + 1) of \(chapters.count)"
        }

        var chapterTitle: String {
            guard chapters.count > currentChapterIndex else { return "Description unavailable" }
            return chapters[currentChapterIndex].title
        }

        var rateTitle: String { "Speed \(playbackRate.stringWithTruncatedZero)x" }
        var hasNextChapter: Bool { chapters.count > currentChapterIndex }
        var hasPreviousChapter: Bool { currentChapterIndex > .zero }
    }
}

extension Player {
    enum Action: Equatable {
        case viewAppeared
        case audiobookLoaded(TaskResult<Audiobook>)
        case chapterLoaded(TaskResult<Double>)
        case playbackProgressUpdated(PlayerProgress)

        case chapterChanged
        case rateButtonTapped
        case progress(SliderReducer.Action)
        case controls(PlayerActionButtonsReducer.Action)
        case mode(ModeSelectorReducer.Action)

        case alertDismissed
        case modeAlertDismissed
        case retryChapterLoadingTapped
        case retryAudiobookLoadingTapped
        case buyPremiumTapped
        case purchased
    }
}

struct Player: Reducer {
    @Dependency(\.storeService) var storeService
    @Dependency(\.audiobookProvider) var audiobookProvider
    @Dependency(\.audioplayer) var audioplayer

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
                return loadAudiobook()

            case let .audiobookLoaded(.success(audiobook)):
                state.imageURL = audiobook.imageURL
                state.chapters = audiobook.chapters

                return loadCurrentChapter(for: &state)

            case .audiobookLoaded(.failure):
                state.alert = alert(
                    with: Constants.Alert.bookLoadingFailed,
                    retryAction: .retryAudiobookLoadingTapped
                )

                return .none

            case let .chapterLoaded(.success(time)):
                state.progress.status = .enabled(.init(time: time, 
                                                       step: Constants.Progress.step))
                state.controls.playerState = .paused
                state.controls.hasNextChapter = state.hasNextChapter
                state.controls.hasPreviousChapter = state.hasPreviousChapter

                return .run { send in
                    for await progress in await audioplayer.progress() {
                        await send(.playbackProgressUpdated(progress))
                    }
                }

            case .chapterLoaded(.failure):
                state.progress.status = .disabled
                state.controls.playerState = .disabled
                state.controls.hasNextChapter = state.hasNextChapter
                state.controls.hasPreviousChapter = state.hasPreviousChapter
                state.alert = alert(
                    with: Constants.Alert.chapterLoadingFailed,
                    retryAction: .retryChapterLoadingTapped
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
                    await audioplayer.setPlaybackRate(rate)
                }

            case .alertDismissed:
                state.alert = nil
                return .none

            case .modeAlertDismissed:
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
            case .buyPremiumTapped:
                return .run { send in
                    do {
                        let _ = try await storeService.purchase()
                        await send(.purchased)
                    } catch {
                        print("Failed purchase for: \(error)")
                    }
                }
            case .purchased:
                state.isPremium = storeService.hasPro
                return .none
            }
        }
    }

    // MARK: - Private helpers

    private func reduce(into state: inout State, controlsAction: PlayerActionButtonsReducer.Action) -> Effect<Action> {
        switch controlsAction {
        case .nextButtonTapped:
            state.currentChapterIndex += 1

            return .run { send in
                await send(.chapterChanged)
            }

        case .previousButtonTapped:
            state.currentChapterIndex -= 1

            return .run { send in
                await send(.chapterChanged)
            }

        case .playButtonTapped:
            let playerState = state.controls.playerState
            guard playerState.isEnabled else { return .none }
            state.controls.playerState = playerState.isPlaying ? .paused : .playing

            return .run { [rate = state.playbackRate] _ in
                if playerState.isPlaying {
                    await audioplayer.pause()
                } else {
                    await audioplayer.play(rate)
                }
            }

        case .seekBackButtonTapped:
            return .run { _ in
                await audioplayer.seekBackwardBy(Constants.Progress.seekBackwardInterval)
            }

        case .seekForwardButtonTapped:
            return .run { _ in
                await audioplayer.seekForwardBy(Constants.Progress.seekForwardInterval)
            }
        }
    }

    private func reduce(into _: inout State, progressAction: SliderReducer.Action) -> Effect<Action> {
        switch progressAction {
        case let .sliderUpdated(progress):
            return .run { _ in
                await audioplayer.seekTo(progress)
            }
        }
    }

    private func reduce(into state: inout State, modeAction: ModeSelectorReducer.Action) -> Effect<Action> {
        switch modeAction {
        case .selectorTaped:
            state.alert = alert(
                with: Constants.Alert.modeUnavailable,
                dismissAction: .modeAlertDismissed
            )
        }

        return .none
    }

    private func loadAudiobook() -> Effect<Action> {
        .run { send in
            await send(
                .audiobookLoaded(
                    TaskResult { try await audiobookProvider.audiobook() }
                )
            )
        }
    }

    private func loadCurrentChapter(for state: inout State) -> Effect<Action> {
        guard let chapterUrl = state.chapters[state.currentChapterIndex].audioURL
        else {
            state.alert = alert(with: Constants.Alert.chapterAudioUnavailable)
            return .none
        }

        return .run { send in
            await audioplayer.pause()

            await send(
                .chapterLoaded(
                    TaskResult { try await audioplayer.loadItemAt(chapterUrl) }
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

    private func alert(
        with title: String,
        dismissAction: Action = .alertDismissed
    ) -> AlertState<Action> {
        AlertState {
            TextState(title)
        } actions: {
            ButtonState(action: dismissAction) {
                TextState(Constants.Alert.dismiss)
            }
        }
    }

    private func alert(
        with title: String,
        retryAction: Action
    ) -> AlertState<Action> {
        AlertState {
            TextState(title)
        } actions: {
            ButtonState(action: retryAction) {
                TextState(Constants.Alert.retry)
            }

            ButtonState(action: .alertDismissed) {
                TextState(Constants.Alert.dismiss)
            }
        }
    }
}
