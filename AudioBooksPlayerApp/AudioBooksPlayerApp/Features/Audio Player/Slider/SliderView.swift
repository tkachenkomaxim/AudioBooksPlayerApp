//
//  SliderView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import ComposableArchitecture
import SwiftUI
import UIKit.UISlider

private enum Const {
    enum Labels {
        static let font: Font = .system(size: 13.0, weight: .regular, design: .rounded)
        static let color: Color = .init(uiColor: .gray)
        static let width: CGFloat = 50.0
    }
    
    enum Progress {
        static let title: String = "Progress"
        static let color: UIColor = .systemBlue
        static let step: Double = 1.0
        static let minimumValue: Double = .zero
    }
    
    enum Thumb {
        static let color: Color = .init(uiColor: .systemBlue)
        static let image: UIImage? = UIImage(
            systemName: "circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .medium)
        )
    }
}

struct SliderView: View {
    let store: StoreOf<SliderReducer>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            Slider(
                value: viewStore.binding(
                    get: \.current,
                    send: SliderReducer.Action.sliderUpdated
                ),
                in: .zero ... viewStore.duration,
                step: viewStore.step
            ) {
                Text(Const.Progress.title)
            } minimumValueLabel: {
                Text(viewStore.current.timeCode)
                    .font(Const.Labels.font)
                    .foregroundColor(Const.Labels.color)
                    .frame(width: Const.Labels.width)
            } maximumValueLabel: {
                Text(viewStore.duration.timeCode)
                    .font(Const.Labels.font)
                    .foregroundColor(Const.Labels.color)
                    .frame(width: Const.Labels.width)
            }
            .onAppear(perform: onAppear)
            .disabled(!viewStore.isEnabled)
            .tint(Const.Thumb.color)
        }
    }

    private func onAppear() {
        UISlider.appearance()
            .setThumbImage(Const.Thumb.image, for: .normal)
        UISlider.appearance()
            .minimumTrackTintColor = Const.Progress.color
    }
}


#Preview {
    SliderView(
        store: Store(
            initialState: SliderReducer.State()) {
                SliderReducer()
            }
    )
}
