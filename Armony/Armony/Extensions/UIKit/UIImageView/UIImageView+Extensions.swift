//
//  UIImageView+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 29.08.2021.
//

import UIKit
import AlamofireImage

public enum ImageSource {
    case url(placeholder: UIImage? = nil, URL?)
    case `static`(UIImage?)
}

public extension UIImageView {

    private func set_af_image(url: URL?,
                      placeholderImage: UIImage? = nil,
                      completion: Callback<AFIDataResponse<UIImage>>? = nil) {
        if let url = url {
            af.setImage(withURL: url,
                        placeholderImage: placeholderImage,
                        imageTransition: .crossDissolve(0.25),
                        completion: completion)
        }
        else {
            af.cancelImageRequest()
            image = placeholderImage
        }
    }

    func setImage(source: ImageSource, completion: Callback<UIImage?>? = nil ) {
        switch source {
        case .static(let image):
            self.image = image
            completion?(image)

        case .url(let placeholder, let url):
            set_af_image(url: url, placeholderImage: placeholder) { response in
                completion?(response.value)
            }
        }
    }
}
