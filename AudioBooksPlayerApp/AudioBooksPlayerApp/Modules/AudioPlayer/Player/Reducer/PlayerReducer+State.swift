//
//  PlayerReducer+Helpers.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import ComposableArchitecture

// MARK: - Player+State

extension Player {
    struct State: Equatable {
        
        var isShowAlert: Bool {
            return alert != nil
        }
        
        var isPremium = false
        
        var imageURL: URL?
        var chapters: [Chapter] = []
        var currentChapter: Int = Constants.Progress.defaultChapter
        var speed: Float = Constants.Rate.normal

        var progress: SliderReducer.State = .init()
        var controls: PlayerActionButtonsReducer.State = .init()
        var mode: ModeSelectorReducer.State = .init()

        var alert: BaseBottomPopupModel<Action>?

        var chaptersCountTitle: String {
            guard !chapters.isEmpty else { return String.localizedString(for: "KeyUnv") }
            return "Key point \(currentChapter + 1) of \(chapters.count)"
        }

        var chapterTitle: String {
            guard chapters.count > currentChapter else { return String.localizedString(for: "DescUnv") }
            return chapters[currentChapter].title
        }

        var speedTitle: String { "Speed x\(speed.stringWithTruncatedZero)" }
        var hasNextChapter: Bool { chapters.count - 1 > currentChapter }
        var hasPreviousChapter: Bool { currentChapter > .zero }
    }
}
