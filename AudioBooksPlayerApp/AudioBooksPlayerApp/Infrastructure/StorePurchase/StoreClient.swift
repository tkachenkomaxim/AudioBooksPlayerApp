//
//  StoreClient.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation
import ComposableArchitecture

// MARK: - StoreService + DependencyKey

private enum StoreServiceClientKey: DependencyKey {
    static let liveValue = StoreService()
}

// MARK: - AudiobookService + DependencyValues

extension DependencyValues {
  var storeService: StoreService {
    get { self[StoreServiceClientKey.self] }
    set { self[StoreServiceClientKey.self] = newValue }
  }
}
