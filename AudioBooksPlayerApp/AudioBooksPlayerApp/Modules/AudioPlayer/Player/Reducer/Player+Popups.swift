//
//  Player+Popups.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import UIKit
import SwiftUI

extension Player {
    
    enum PopupStyle {
        case notImplemented
        case chapterLoadingError
        case bookLoadingError
        case purchaseError
        case subcribePremium
    }
    
    
    func popup(_ popup: PopupStyle) -> BaseBottomPopupModel<Action> {
        switch popup {
            
        case .notImplemented:
            return .init(title: String.localizedString(for: "AlertUnimplementedTitle"),
                         content:  String.localizedString(for: "AlertUnimplementedContent"),
                         buttonTitle: "Ok",
                         actionOnTap: .infoAlertDismissed)
            
        case .chapterLoadingError:
            return .init(title: String.localizedString(for: "OOPS"),
                        content: String.localizedString(for: "ChapterLoadingFailed"),
                        buttonTitle: String.localizedString(for: "RetryButton"),
                        actionOnTap: .retryChapterLoadingTapped)
            
        case .bookLoadingError:
            return .init(title: String.localizedString(for: "OOPS"),
                         content: String.localizedString(for: "BooksLoadingFailed"),
                         buttonTitle: String.localizedString(for: "RetryButton"),
                         actionOnTap: .retryAudiobookLoadingTapped)
            
        case .purchaseError:
            return .init(title: String.localizedString(for: "OOPS"),
                         content: String.localizedString(for: "PurchaseErrorContent"),
                         buttonTitle: String.localizedString(for: "RetryButton"),
                         actionOnTap: .buyPremiumTapped)
            
        case .subcribePremium:
            return .init(title: String.localizedString(for: "StorePurchaseTitle"),
                        content: String.localizedString(for: "StorePurchaseContent"),
                        buttonTitle: String.localizedString(for: "StorePurchaseButton"),
                        actionOnTap: .buyPremiumTapped)
        }
    }
}
