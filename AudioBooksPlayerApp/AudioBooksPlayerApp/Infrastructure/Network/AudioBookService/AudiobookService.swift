//
//  AudiobookProvider.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import Foundation

struct AudiobookService {
    var audiobook: @Sendable () async throws -> Audiobook
}

// MARK: - Live

extension AudiobookService {
    static let live = AudiobookService {
        let (data, _) = try await URLSession.shared.data(from: AudiobookRequest.url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let audioBookAnswer = try decoder.decode(AudiobookAnswer.self, from: data)
        return Audiobook(from: audioBookAnswer)
    }
}
