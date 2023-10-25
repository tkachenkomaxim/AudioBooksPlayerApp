//
//  AudioBookRequest.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation

struct AudiobookRequest {
    
    static let urlString = "https://raw.githubusercontent.com/tkachenkomaxim/booksarchive/main/books.json"
    static let url = URL(string: urlString)!
}
