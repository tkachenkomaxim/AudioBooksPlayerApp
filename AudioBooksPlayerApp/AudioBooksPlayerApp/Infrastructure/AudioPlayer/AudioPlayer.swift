//
//  AudioPlayer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import AVFoundation
import ComposableArchitecture
import Foundation

enum AudioPlayerError: Error {
    case invalidItemDuration
}

enum PlayerProgress: Equatable {
    case value(Double)
    case ended
}

struct AudioPlayer {
    var loadItemAt: @Sendable (URL) async throws -> Double
    var progress: @Sendable () async -> AsyncStream<PlayerProgress>
    var play: @Sendable (_ rate: Float) async -> Void
    var pause: @Sendable () async -> Void
    var seekTo: @Sendable (Double) async -> Void
    var seekForwardBy: @Sendable (Double) async -> Void
    var seekBackwardBy: @Sendable (Double) async -> Void
    var setPlaybackRate: @Sendable (Float) async -> Void
}

// MARK: - Live

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
                throw AudioPlayerError.invalidItemDuration
            }

            return itemDuration
        } progress: {
            AsyncStream<PlayerProgress> { continuation in
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
        } setPlaybackRate: { rate in
            controller.player.rate = rate
        }
    }()
}

// MARK: - AudioPlayer + DependencyValues

extension DependencyValues {
    var audioplayer: AudioPlayer {
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
        } setPlaybackRate: { _ in
        }
    }
}
