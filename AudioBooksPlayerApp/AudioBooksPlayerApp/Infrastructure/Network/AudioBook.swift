//
//  AudioBook.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct Audiobook {
    let title: String
    let imageURL: URL?
    let chapters: [Chapter]
}

// MARK: - Convenience init

extension Audiobook {
    init(from dtoModel: AudiobookDTO) {
        title = dtoModel.bookTitle
        imageURL = URL(string: dtoModel.bookCover)
        chapters = dtoModel.chapters
            .sorted { $0.order < $1.order }
            .compactMap { Chapter(from: $0) }
    }
}

// MARK: - Audiobook + Equatable

extension Audiobook: Equatable {}

// MARK: - Mock

extension Audiobook {
    static var mock: Audiobook {
        .init(
            title: "Mock audiobook",
            imageURL: URL(string: "https://mock/image.jpeg"),
            chapters: Chapter.mocks
        )
    }
}

