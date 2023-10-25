//
//  AudioPlayerClient.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import Dependencies

// MARK: - AudioPlayer + DependencyValues

extension DependencyValues {
    
    var player: AudioPlayer {
        get { self[AudioPlayer.self] }
        set { self[AudioPlayer.self] = newValue }
    }
}

// MARK: - AudioPlayer + DependencyKey

extension AudioPlayer: DependencyKey {
    
    static var liveValue: AudioPlayer {
        .live
    }

    static var testValue: AudioPlayer {
        AudioPlayer { _ in
            100.0
        } progress: {
            .finished
        } play: { _ in
        } pause: {} seekTo: { _ in
        } seekForwardBy: { _ in
        } seekBackwardBy: { _ in
        } changeSpeed: { _ in
        }
    }
}
