//
//  AudioBookServiceClient.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import Dependencies

// MARK: - AudiobookService + DependencyValues

extension DependencyValues {
    var audiobookService: AudiobookService {
        get { self[AudiobookService.self] }
        set { self[AudiobookService.self] = newValue }
    }
}

// MARK: - AudiobookService + DependencyKey

extension AudiobookService: DependencyKey {
    static var liveValue: AudiobookService {
        .live
    }

    static var testValue: AudiobookService {
        AudiobookService {
            .mock
        }
    }
}
