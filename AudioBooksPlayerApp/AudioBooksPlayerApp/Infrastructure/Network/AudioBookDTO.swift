//
//  AudioBookDTO.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct AudiobookDTO: Decodable {
    let bookTitle: String
    let bookCover: String
    let chapters: [ChapterDTO]
}
