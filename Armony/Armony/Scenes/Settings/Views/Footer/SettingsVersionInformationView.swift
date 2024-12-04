//
//  SettingsVersionInformationView.swift
//  Armony
//
//  Created by Koray Yildiz on 04.08.22.
//

import UIKit

final class SettingsVersionInformationView: UIView {

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .lightSubheading
        label.textColor = .armonyWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            versionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            versionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 42),
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(version: String) {
        versionLabel.text = "\(String("Version", table: .common)): \(version)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
