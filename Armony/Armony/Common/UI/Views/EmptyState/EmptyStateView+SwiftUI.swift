//
//  EmptyStateView+SwiftUI.swift
//  Armony
//
//  Created by KORAY YILDIZ on 25/10/2024.
//

import SwiftUI

struct EmptyStateSwiftUIView: UIViewRepresentable {

    typealias UIViewType = EmptyStateView

    private let action: Callback<UIButton>?
    private let presentation: EmptyStatePresentation

    init(presentation: EmptyStatePresentation, action: Callback<UIButton>?) {
        self.presentation = presentation
        self.action = action
    }

    func makeUIView(context: Context) -> EmptyStateView {
        let view = EmptyStateView()
        view.configure(with: presentation, action: action)
        return view
    }
    
    func updateUIView(_ uiView: EmptyStateView, context: Context) {
        uiView.configure(with: presentation, action: action)
    }
}
