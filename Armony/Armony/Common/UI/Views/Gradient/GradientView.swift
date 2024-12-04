//
//  GradientView.swift
//  Armony
//
//  Created by Koray Yıldız on 20.11.2021.
//

import UIKit

final class GradientView: UIView, NibLoadable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public func configure(with presentation: GradientPresentation) {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

        gradientLayer.startPoint = presentation.orientation.startPoint
        gradientLayer.endPoint = presentation.orientation.endPoint
        gradientLayer.colors = presentation.color.colors.map { return $0.cgColor }
    }
}
