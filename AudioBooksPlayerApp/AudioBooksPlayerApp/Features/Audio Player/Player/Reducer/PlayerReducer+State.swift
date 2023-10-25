//
//  PlayerReducer+Helpers.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import ComposableArchitecture

extension Player {
    struct State: Equatable {
        var isShowAlert: Bool {
            return alert != nil
        }
        
        var isPremium = false
        
        var imageURL: URL?
        var chapters: [Chapter] = []
        var currentChapterIndex: Int = Constants.defaultChapterIndex
        var playbackRate: Float = Constants.Rate.standart

        var progress: SliderReducer.State = .init()
        var controls: PlayerActionButtonsReducer.State = .init()
        var mode: ModeSelectorReducer.State = .init()

        var alert: BaseBottomPopupModel<Action>?

        var chaptersCountTitle: String {
            guard !chapters.isEmpty else { return "Keypoints unavailable" }
            return "Key point \(currentChapterIndex + 1) of \(chapters.count)"
        }

        var chapterTitle: String {
            guard chapters.count > currentChapterIndex else { return "Description unavailable" }
            return chapters[currentChapterIndex].title
        }

        var rateTitle: String { "Speed \(playbackRate.stringWithTruncatedZero)x" }
        var hasNextChapter: Bool { chapters.count - 1 > currentChapterIndex }
        var hasPreviousChapter: Bool { currentChapterIndex > .zero }
    }
}
