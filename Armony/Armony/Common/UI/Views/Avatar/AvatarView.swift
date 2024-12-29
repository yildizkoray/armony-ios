//
//  AvatarView.swift
//  Armony
//
//  Created by Koray Yıldız on 28.08.2021.
//

import UIKit

final class AvatarView: UIView, NibLoadable {

    @IBOutlet weak var borderImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configure()
    }

    private func configure() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = .avatarPlaceholder
    }

    func configure(with presentation: AvatarPresentation) {
        if borderImageViewWidthConstraint.constant != presentation.kind.size.width {
            borderImageViewWidthConstraint.constant = presentation.kind.size.width
        }
        imageView.setImage(source: presentation.source) { [weak self] _ in
            switch presentation.kind {
            case .circled:
                DispatchQueue.main.async {
                    self?.imageView.circled()
                }
            case .custom(let config):
                self?.imageView.makeAllCornersRounded(radius: config.radius.ifNil(.medium))
            }
        }
    }
    
    func update(source: ImageSource) {
        imageView.setImage(source: source)
    }
}
