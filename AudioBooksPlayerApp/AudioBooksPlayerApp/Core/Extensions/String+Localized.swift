//
//  String+Localized.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 26.10.2023.
//

import Foundation

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        
        let language = locale.language.languageCode?.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}
