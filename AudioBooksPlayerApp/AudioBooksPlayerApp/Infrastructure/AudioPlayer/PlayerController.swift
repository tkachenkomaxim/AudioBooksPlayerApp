//
//  PlayerController.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import AVFoundation
import Foundation

private enum Constants {
    static let progressInterval: CMTime = .init(
        seconds: 0.5,
        preferredTimescale: CMTimeScale(NSEC_PER_SEC)
    )
}

enum PlayerControllerError: Error {
    case itemLoadingFailed
}

final class PlayerController {
    let player: AVPlayer

    private let notificationCenter: NotificationCenter
    private var progressContinuation: AsyncStream<PlayerProgress>.Continuation?

    init(
        player: AVPlayer = .init(),
        notificationCenter: NotificationCenter = .default
    ) {
        self.player = player
        self.notificationCenter = notificationCenter
    }

    func fetchDuration(
        of playerItem: AVPlayerItem,
        into continuation: AsyncThrowingStream<Double, Error>.Continuation
    ) {
        let observation = playerItem.observe(\.status) { item, _ in
            switch item.status {
            case .readyToPlay:
                continuation.yield(item.duration.seconds)
                continuation.finish()
            default:
                continuation.finish(throwing: PlayerControllerError.itemLoadingFailed)
            }
        }

        continuation.onTermination = { _ in
            observation.invalidate()
        }
    }

    func streamPlaybackProgress(into continuation: AsyncStream<PlayerProgress>.Continuation) {
        progressContinuation = continuation

        let progressObserer = player.addPeriodicTimeObserver(
            forInterval: Constants.progressInterval,
            queue: .main
        ) { progress in
            continuation.yield(.value(progress.seconds))
        }

        if let playerItem = player.currentItem {
            setupPlaybackFinishedObserver(for: playerItem)
        }

        continuation.onTermination = { [weak self] _ in
            self?.player.removeTimeObserver(progressObserer)
            self?.removePlaybackFinishedObserver(for: self?.player.currentItem)
        }
    }

    // MARK: - Private helpers

    private func setupPlaybackFinishedObserver(for item: AVPlayerItem) {
        notificationCenter.addObserver(
            self,
            selector: #selector(itemPlaybackDidFinish),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }

    private func removePlaybackFinishedObserver(for item: AVPlayerItem?) {
        notificationCenter.removeObserver(
            self,
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }

    @objc
    private func itemPlaybackDidFinish() {
        progressContinuation?.yield(.ended)
    }
}

