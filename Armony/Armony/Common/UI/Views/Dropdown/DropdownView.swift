//
//  DropdownView.swift
//  Armony
//
//  Created by Koray Yildiz on 30.05.22.
//

import UIKit
import SkyFloatingLabelTextField

class DropdownView: UIView, NibLoadable {

    @IBOutlet private(set) weak var textField: SkyFloatingLabelTextField!
    @IBOutlet private weak var accessoryView: UIImageView! {
        didSet {
            cachedAccessoryImage = accessoryView.image
        }
    }

    private lazy var cachedAccessoryImage: UIImage? = nil

    private lazy var _activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.create(color: .white)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: accessoryView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor).isActive = true
        view.hidesWhenStopped = true
        return view
    }()

    override var activityIndicatorView: UIActivityIndicatorView {
        return _activityIndicatorView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configureUI()
    }

    func configure(with presentation: DropdownPresentation) {
        textField.placeholder = presentation.placeholder
        textField.title = presentation.title
    }

    private func configureUI() {
        backgroundColor = .clear
        makeBordered(color: .blue)
        makeAllCornersRounded(radius: .low)

        textField.tintColor = .clear
        textField.isUserInteractionEnabled = false

        textField.lineHeight = .zero
        textField.lineColor = .clear
        textField.selectedLineColor = .clear
        textField.lineErrorColor = .clear

        textField.placeholderFont = .lightSubheading
        textField.placeholderColor = .armonyWhiteMedium

        textField.font = .lightSubheading
        textField.textColor = .armonyWhite

        textField.titleFont = .lightBody
        textField.titleColor = .armonyWhite

        textField.titleFormatter = { $0 }
    }

    func updateText(_ text: String?) {
        textField.text = text
    }

    override func startActivityIndicatorView() {
        super.startActivityIndicatorView()
        isUserInteractionEnabled = false
        accessoryView.image = nil
    }

    override func stopActivityIndicatorView() {
        super.stopActivityIndicatorView()
        isUserInteractionEnabled = true
        accessoryView.image = cachedAccessoryImage
    }
}
