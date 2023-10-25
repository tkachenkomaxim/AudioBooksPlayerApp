//
//  URLImageView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//
import Foundation
import SwiftUI

private enum Constants {
    static let placeholder: String = "doc.plaintext.fill"
}

struct URLImageView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .failure:
                Image(systemName: Constants.placeholder)
                    .resizable()
                    .foregroundColor(.posterForground)
            case let .success(image):
                image.resizable()
            @unknown default:
                Image(Constants.placeholder)
                    .resizable()
            }
        }
    }
}
