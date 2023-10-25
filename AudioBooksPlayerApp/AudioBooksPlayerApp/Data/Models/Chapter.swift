//
//  Chapter.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation

struct Chapter: Equatable {
    
    let title: String
    let audioURL: URL?
}

// MARK: - Convenience init

extension Chapter {
    
    init(from answer: ChapterAnswer) {
        
        title = answer.name
        audioURL = URL(string: answer.audio)
    }
}
