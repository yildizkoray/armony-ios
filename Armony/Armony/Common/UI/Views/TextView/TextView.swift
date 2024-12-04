//
//  TextView.swift
//  Armony
//
//  Created by Koray Yildiz on 06.06.22.
//

import UIKit

protocol TextViewDelegate: AnyObject {
    func textViewDidEndEditing(_ textView: UITextView)
    func textViewDidChange(_ textView: UITextView)
}

extension TextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) { }
    func textViewDidChange(_ textView: UITextView) { }
}

class TextView: UIView, NibLoadable {

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private(set) weak var textView: UITextView!
    @IBOutlet private weak var counterLabel: UILabel!

    weak var delegate: TextViewDelegate?

    private var presentation: TextViewPresentation = .empty

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 185)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configure()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configure()
        addTapGesture()
    }

    private func addTapGesture() {
        addTapGestureRecognizer { [weak self] _ in
            self?.textView.becomeFirstResponder()
        }
    }

    func updateText(_ text: String) {
        textView.text = text
        updateCounterLabel(numberOfChar: text.count)
        if text.isEmpty {
            updateCounterLabelDefaultAppearanceIfNeeded()
            updatePlaceholderDefaultAppearanceIfNeeded()
        }
        else {
            updatePlaceholderEditingAppearance()
            updateCounterEditingAppearance()
        }
    }

    func configure(with presentation: TextViewPresentation) {
        self.presentation = presentation
        placeholderLabel.text = presentation.placeholder
        counterLabel.text = "0/\(presentation.numberOfMaximumChar)"
    }

    private func configure() {
        makeBordered(color: .blue)
        makeAllCornersRounded(radius: .low)

        textView.delegate = self
        textView.textContainer.lineFragmentPadding = .zero
        textView.text = .empty
        textView.textColor = .armonyWhite
        textView.font = .regularBody

        placeholderLabel.textColor = .armonyWhiteMedium
        placeholderLabel.font = .lightSubheading

        counterLabel.textColor = .armonyWhiteMedium
        counterLabel.font = .lightSubheading
    }

    private func updatePlaceholderEditingAppearance() {
        placeholderLabel.textColor = .armonyWhite
        placeholderLabel.font = .lightBody
    }

    private func updateCounterEditingAppearance() {
        counterLabel.textColor = .armonyWhite
        counterLabel.font = .lightBody
    }

    private func updatePlaceholderDefaultAppearanceIfNeeded() {
        if textView.text.isEmpty {
            placeholderLabel.textColor = .armonyWhiteMedium
            placeholderLabel.font = .lightSubheading
        }
    }

    private func updateCounterLabelDefaultAppearanceIfNeeded() {
        if textView.text.isEmpty {
            counterLabel.textColor = .armonyWhiteMedium
            counterLabel.font = .lightBody
        }
    }

    private func updateCounterLabel(numberOfChar: Int) {
        counterLabel.text = "\(numberOfChar)/\(presentation.numberOfMaximumChar)"
    }
}

// MARK: - UITextViewDelegate
extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateCounterLabel(numberOfChar: textView.text.count)
        delegate?.textViewDidChange(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholderEditingAppearance()
        updateCounterEditingAppearance()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateCounterLabelDefaultAppearanceIfNeeded()
        updatePlaceholderDefaultAppearanceIfNeeded()
        delegate?.textViewDidEndEditing(textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= presentation.numberOfMaximumChar
    }
}
