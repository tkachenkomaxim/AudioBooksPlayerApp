//
//  Chapter.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct Chapter {
    let title: String
    let audioURL: URL?
}

// MARK: - Convenience init

extension Chapter {
    init(from dtoModel: ChapterDTO) {
        title = dtoModel.name
        audioURL = URL(string: dtoModel.audio)
    }
}

// MARK: - Chapter + Equatable

extension Chapter: Equatable {}

// MARK: - Mock

extension Chapter {
    static var mock: Chapter {
        .init(
            title: "Chapter 1",
            audioURL: URL(string: "https://mock/chapter_1")
        )
    }

    static var mocks: [Chapter] {
        [
            Chapter(
                title: "Chapter 1",
                audioURL: URL(string: "https://mock/chapter_1")
            ),
            Chapter(
                title: "Chapter 2",
                audioURL: URL(string: "https://mock/chapter_2")
            ),
            Chapter(
                title: "Chapter 3",
                audioURL: URL(string: "https://mock/chapter_3")
            ),
        ]
    }
}

