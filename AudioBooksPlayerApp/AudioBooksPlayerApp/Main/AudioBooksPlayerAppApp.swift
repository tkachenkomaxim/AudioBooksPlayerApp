//
//  AudioBooksPlayerAppApp.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct AudioBooksPlayerAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            PlayerView(
                store: Store(
                    initialState: Player.State()) {
                        Player()
                    }
            )
        }
    }
}
