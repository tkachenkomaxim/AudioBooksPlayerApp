//
//  AudioBooksPlayerAppTests.swift
//  AudioBooksPlayerAppTests
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

@testable import AudioBooksPlayerApp
import ComposableArchitecture
import XCTest

@MainActor
final class PlayerTests: XCTestCase {
    
    func testLoadingChapterFailure() async {

        let store = TestStore(initialState: Player.State()) {
            Player()
        } withDependencies: {
            $0.player.itemAt = { _ in throw AudioPlayerError.invalidItemDuration }
        }

        await store.send(.audiobookLoaded(.success(.mock))) {
            $0.imageURL = Audiobook.mock.imageURL
            $0.chapters = Audiobook.mock.chapters
        }

        await store.receive(.chapterLoaded(.failure(AudioPlayerError.invalidItemDuration))) {
            $0.progress.status = .disabled
            $0.controls.playerState = .disabled
            $0.controls.hasNextChapter = true
            $0.controls.hasPreviousChapter = false
            $0.alert =  BaseBottomPopupModel(
                    title: "Oops",
                    content: "Sorry, chapter audio loading failed ☹️",
                    buttonTitle: "Retry",
                    actionOnTap: .retryChapterLoadingTapped
            )
        }
    }
    
    func testProgressUpdates() async {

        let store = TestStore(initialState: Player.State()) {
            Player()
        } withDependencies: {
            $0.player.progress = { .init {
                for progress in 1 ... 3 {
                    $0.yield(.value(Double(progress)))
                }
                $0.finish()
            } }
        }

        await store.send(.chapterLoaded(.success(350.0))) {
            $0.progress.status = .enabled(.init(time: 350.0, step: 1.0))
            $0.controls.playerState = .paused
            $0.controls.hasNextChapter = false
            $0.controls.hasPreviousChapter = false
        }

        await store.receive(.playbackProgressUpdated(.value(1.0))) {
            $0.progress.current = 1.0
        }

        await store.receive(.playbackProgressUpdated(.value(1.9))) {
            $0.progress.current = 1.9
        }
    }
    
    func testLoadingChapter() async {

        let store = TestStore(initialState: Player.State()) {
            Player()
        }

        await store.send(.audiobookLoaded(.success(.mock))) {
            $0.imageURL = Audiobook.mock.imageURL
            $0.chapters = Audiobook.mock.chapters
        }

        await store.receive(.chapterLoaded(.success(250.0))) {
            $0.progress.status = .enabled(.init(time: 250.0, step: 1.0))
            $0.controls.playerState = .paused
            $0.controls.hasNextChapter = true
            $0.controls.hasPreviousChapter = false
        }
    }
}
