//
//  AudioBookDTO.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct AudiobookAnswer: Decodable {
    let bookTitle: String
    let bookCover: String
    let chapters: [ChapterAnswer]
}
