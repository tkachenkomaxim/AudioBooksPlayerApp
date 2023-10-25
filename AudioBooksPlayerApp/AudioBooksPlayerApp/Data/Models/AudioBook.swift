//
//  AudioBook.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct Audiobook: Equatable {
    
    let title: String
    let imageURL: URL?
    let chapters: [Chapter]
}

// MARK: - Convenience init

extension Audiobook {
    
    init(from answer: AudiobookAnswer) {
        title = answer.bookTitle
        imageURL = URL(string: answer.bookCover)
        chapters = answer.chapters
            .sorted { $0.id < $1.id }
            .compactMap { Chapter(from: $0) }
    }
}
