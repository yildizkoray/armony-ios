//
//  SwiftUICardView.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/09/2024.
//

import SwiftUI

struct SwiftUICardView: UIViewRepresentable {

    typealias UIViewType = CardView

    private let presentation: CardPresentation

    init(presentation: CardPresentation) {
        self.presentation = presentation
    }

    func makeUIView(context: Context) -> CardView {
        let view = CardView()
        view.makeAllCornersRounded(radius: .medium)
        return view
    }

    func updateUIView(_ uiView: CardView, context: Context) {
        uiView.configure(presentation: presentation)
    }
}
