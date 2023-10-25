//
//  ChapterDTO.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct ChapterAnswer: Decodable  {
    let id: Int
    let name: String
    let audio: String
}
