//
//  LeftAlignedFlowLayout.swift
//  Armony
//
//  Created by Koray Yildiz on 20.04.23.
//

import UIKit

public class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var leftMargin: CGFloat = .zero
        var lastY: CGFloat = .zero

        return originalAttributes.map {
            if $0.representedElementKind == UICollectionView.elementKindSectionHeader ||
                $0.representedElementKind == UICollectionView.elementKindSectionHeader {
                return $0
            }

            let changedAttribute = $0
            if changedAttribute.center.y != lastY {
                leftMargin = sectionInset.left
            }
            changedAttribute.frame.origin.x = leftMargin
            lastY = changedAttribute.center.y
            leftMargin += changedAttribute.frame.width + minimumInteritemSpacing
            if leftMargin <= sectionInset.left {
                leftMargin = sectionInset.left
            }
            return changedAttribute
        }
    }
}
