//
//  AudioPlayer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import AVFoundation
import ComposableArchitecture
import Foundation

// MARK: - Error

enum AudioPlayerError: Error {
    
    case invalidDuration
}

// MARK: - Progress

enum PlayerSlider: Equatable {
    
    case value(Double)
    case ended
}

// MARK: - Actions

struct AudioPlayer {
    
    var itemAt: @Sendable (URL) async throws -> Double
    var progress: @Sendable () async -> AsyncStream<PlayerSlider>
    var play: @Sendable (_ rate: Float) async -> Void
    var pause: @Sendable () async -> Void
    var seekTo: @Sendable (Double) async -> Void
    var seekForwardBy: @Sendable (Double) async -> Void
    var seekBackwardBy: @Sendable (Double) async -> Void
    var changeSpeed: @Sendable (Float) async -> Void
}

// MARK: - Live Value

extension AudioPlayer {
    
    static let live: Self = {
        let controller = PlayerController()

        return AudioPlayer { url in
            let playerItem = AVPlayerItem(url: url)
            controller.player.replaceCurrentItem(with: playerItem)

            let stream = AsyncThrowingStream<Double, Error> { continuation in
                controller.fetchDuration(of: playerItem, into: continuation)
            }

            guard let itemDuration = try await stream.first(where: { _ in true }) else {
                throw AudioPlayerError.invalidDuration
            }

            return itemDuration
        } progress: {
            AsyncStream<PlayerSlider> { continuation in
                controller.streamPlaybackProgress(into: continuation)
            }
        } play: { rate in
            controller.player.play()
            controller.player.rate = rate
        } pause: {
            controller.player.pause()
        } seekTo: { timecode in
            await controller.player.seek(to: timecode.cmTime())
        } seekForwardBy: { timeInterval in
            let duration = controller.player.currentItem?.duration.seconds ?? .zero
            let currentTimecode = controller.player.currentTime()
            let targetTimecode = min(currentTimecode.seconds + timeInterval, duration)

            await controller.player.seek(to: targetTimecode.cmTime())
        } seekBackwardBy: { timeInterval in
            let currentTimecode = controller.player.currentTime()
            let targetTimecode = max(currentTimecode.seconds - timeInterval, .zero)

            await controller.player.seek(to: targetTimecode.cmTime())
        } changeSpeed: { rate in
            controller.player.rate = rate
        }
    }()
}
