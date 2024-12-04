//
//  SelectionBottomPopUpFooterView.swift
//  Armony
//
//  Created by Koray Yildiz on 08.01.23.
//

import UIKit

public class SelectionBottomPopUpFooterView: UITableViewHeaderFooterView {

    var continueButtonTapped: VoidCallback? = nil

    private lazy var continueButton: UIButton = {
        let continueButton = UIButton(type: .system)
        continueButton.configuration = .none
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.titleLabel?.font = .semiboldHeading
        continueButton.setTitleColor(.armonyWhite, for: .normal)
        continueButton.backgroundColor = .armonyPurple
        continueButton.makeAllCornersRounded(radius: .medium)
        continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        continueButton.setTitle(
            String(localized: "Common.Continue", table: "Common+Localizable"), for: .normal
        )
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        return continueButton
    }()

    @objc private func continueButtonDidTap() {
        continueButtonTapped?()
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: .zero, right: 16.0)
        addSubviewAndConstraintsToEdges(continueButton, insets: insets)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func updateConfiguration(using state: UIViewConfigurationState) {
        var config = UIBackgroundConfiguration.listPlainHeaderFooter()
        config.backgroundColor = .armonyBlack
        backgroundConfiguration = config
    }

    func configure(with buttonTitle: String) {
        continueButton.setTitle(buttonTitle, for: .normal)
    }
}
