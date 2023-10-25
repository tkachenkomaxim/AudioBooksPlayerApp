//
//  URLImageView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//
import Foundation
import SwiftUI

// MARK: - Constant

private enum Const {
    
    static let placeholder: String = "doc.plaintext.fill"
    static let radius: CGFloat = 10
}

struct URLImageView: View {
    
    // MARK: - Public Props
    
    let url: URL?
    
    // MARK: - View

    var body: some View {
        
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .failure:
                Image(systemName: Const.placeholder)
                    .resizable()
                    .foregroundColor(.posterForground)
            case let .success(image):
                image.resizable()
            @unknown default:
                Image(Const.placeholder)
                    .resizable()
            }
        }
        .cornerRadius(Const.radius)
    }
}
