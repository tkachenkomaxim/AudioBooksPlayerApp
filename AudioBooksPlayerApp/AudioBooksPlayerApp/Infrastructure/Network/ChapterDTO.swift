//
//  ChapterDTO.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct ChapterDTO: Decodable  {
    let order: Int
    let name: String
    let audio: String
}
