//
//  PlayerController.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import AVFoundation
import Foundation

// MARK: - Constants

private enum Constants {
    
    static let progressInterval: CMTime = .init(
        seconds: 0.5,
        preferredTimescale: CMTimeScale(NSEC_PER_SEC)
    )
}

// MARK: - Error

enum PlayerControllerError: Error {
    
    case itemLoadingFailed
}

final class PlayerController {
    
    // MARK: - Public Props
    
    let player: AVPlayer
    
    // MARK: - Private Props

    private let notificationCenter: NotificationCenter
    private var progressContinuation: AsyncStream<PlayerSlider>.Continuation?
    
    // MARK: - Lifecycle

    init(
        player: AVPlayer = .init(),
        notificationCenter: NotificationCenter = .default
    ) {
        
        self.player = player
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Public Func

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

    func streamPlaybackProgress(into continuation: AsyncStream<PlayerSlider>.Continuation) {
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

    // MARK: - Private Func

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
    
    // MARK: - Selectors

    @objc
    private func itemPlaybackDidFinish() {
        
        progressContinuation?.yield(.ended)
    }
}

