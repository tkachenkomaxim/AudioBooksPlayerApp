//
//  PopupViewModifier.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//
import SwiftUI

public struct PopupViewModifier<Popup: View>: ViewModifier {
    public var isShow: Bool
    @ViewBuilder public let popup: Popup

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShow {
                popup
            }
        }
    }
}

public extension View {
    func customPopup<Popup: View>(isShow: Bool, @ViewBuilder popup: () -> Popup) -> some View {
        modifier(PopupViewModifier(isShow: isShow, popup: popup))
    }
}
