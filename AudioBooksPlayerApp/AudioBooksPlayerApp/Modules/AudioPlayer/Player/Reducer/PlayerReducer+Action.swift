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
        
        case buyPremiumTapped
        case purchased
        case purchaseError
        
        case progress(SliderReducer.Action)
        case controls(PlayerActionButtonsReducer.Action)
        case mode(ModeSelectorReducer.Action)
        
        case audiobookLoaded(TaskResult<Audiobook>)
        case chapterLoaded(TaskResult<Double>)
        case sliderUpdated(PlayerSlider)

        case chapterChanged
        case rateButtonTapped

        case alertDismissed
        case infoAlertDismissed
        case retryChapterLoadingTapped
        case retryAudiobookLoadingTapped
    }
}
