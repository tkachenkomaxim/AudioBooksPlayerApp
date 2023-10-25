//
//  PlayerReducer+Action.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import ComposableArchitecture

// MARK: - Player+Action

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
        case purchaseError
    }
}
