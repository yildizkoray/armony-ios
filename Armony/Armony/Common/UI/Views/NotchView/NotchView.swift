//
//  NotchView.swift
//  Armony
//
//  Created by Koray Yildiz on 15.06.22.
//

import UIKit
import SwiftUI

final class NotchView: UIView, NibLoadable {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: 34.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }
}

struct NotchViewSwiftUI: UIViewRepresentable {

    typealias UIViewType = NotchView

    var configure: Callback<UIViewType>? = nil

    func makeUIView(context: Context) -> NotchView {
        return UIViewType()
    }

    func updateUIView(_ uiView: NotchView, context: Context) {
        configure?(uiView)
    }
}

struct PolicyTextView: UIViewRepresentable {

    typealias UIViewType = UITextView
    var configure: Callback<UIViewType>? = nil

    func makeUIView(context: Context) -> UITextView {
        return UIViewType()
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        configure?(uiView)
    }
}
