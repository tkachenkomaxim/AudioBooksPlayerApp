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
        
    
    let audioBook = Audiobook.init(
        title: "Mock audiobook",
        imageURL: URL(string: "https://mock/mock.jpeg"),
        chapters: [Chapter(
            title: "Mock Chapter 1",
            audioURL: URL(string: "https://mock/chapter_1")
        ),
        Chapter(
            title: "Mock Chapter 2",
            audioURL: URL(string: "https://mock/chapter_2")
        ),
        Chapter(
            title: "Mock Chapter 3",
            audioURL: URL(string: "https://mock/chapter_3")
        )]
    )
    
    
    
    func testPurchaseFailure() async {

        let player = Player()
        let store = TestStore(initialState: Player.State()) {
           player
        }

        await store.send(.purchaseError) {
            $0.alert = player.popup(.purchaseError)
        }
    }
    
    func testPurchase() async {

        let player = Player()
        let store = TestStore(initialState: Player.State()) {
           player
        } withDependencies: {
            $0.storeService.hasPro = true
        }

        await store.send(.purchased) {
            $0.isPremium = true
        }
    }
    
    func testLoadingChapterFailure() async {

        let player = Player()
        let store = TestStore(initialState: Player.State()) {
           player
        } withDependencies: {
            $0.player.itemAt = { _ in throw AudioPlayerError.invalidDuration }
        }

        await store.send(.audiobookLoaded(.success(self.audioBook))) {
            $0.imageURL = self.audioBook.imageURL
            $0.chapters = self.audioBook.chapters
        }

        await store.receive(.chapterLoaded(.failure(AudioPlayerError.invalidDuration))) {
            $0.progress.status = .disabled
            $0.controls.playerState = .disabled
            $0.controls.hasNextChapter = true
            $0.controls.hasPreviousChapter = false
            $0.alert = player.popup(.chapterLoadingError)
        }
    }
    
    func testLoadingChapter() async {
        
        let store = TestStore(initialState: Player.State()) {
            Player()
        }

        await store.send(.audiobookLoaded(.success(self.audioBook))) {
            $0.imageURL = self.audioBook.imageURL
            $0.chapters = self.audioBook.chapters
        }

        await store.receive(.chapterLoaded(.success(100.0))) {
            $0.progress.status = .enabled(.init(time: 100.0, step: 1.0))
            $0.controls.playerState = .paused
            $0.controls.hasNextChapter = true
            $0.controls.hasPreviousChapter = false
        }
    }
}
