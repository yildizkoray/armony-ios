//
//  ImagePickerHandler.swift
//  Armony
//
//  Created by Koray Yildiz on 06.06.22.
//

import Foundation
import UIKit
import Photos

public protocol ImagePickerHandlerDelegate: AnyObject {
    func imagePicker(_ picker: UIImagePickerController, didSelectImage image: UIImage)
}

public final class ImagePickerHandler: NSObject {

    private let imagePickerController: UIImagePickerController
    private weak var viewContoller: UIViewController?
    private weak var delegate: ImagePickerHandlerDelegate?

    public init(to viewContoller: UIViewController, delegate: ImagePickerHandlerDelegate) {
        self.imagePickerController = UIImagePickerController()
        self.delegate = delegate
        self.viewContoller = viewContoller

        super.init()

        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.modalPresentationStyle = .fullScreen
        self.imagePickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.imagePickerController.sourceType = type
            switch type {
            case .photoLibrary, .savedPhotosAlbum:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        safeSync {
                            self.viewContoller?.present(self.imagePickerController, animated: true)
                        }
                    case .denied:
                        let title = String("Settings", table: .common)
                        let goSettings = UIAlertAction(title: title, style: .default) { _ in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        }
                        AlertService.show(title: "Galerine erişim izni vermen gerekiyor",
                                          message: "Gizlilik Ayarlarından izin verebilirsiniz",
                                          actions: [.cancel(), goSettings])
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let title = String("UploadPhoto", table: .common)
        if let action = self.action(for: .savedPhotosAlbum, title: title) {
            alertController.addAction(action)
        }

        alertController.addAction(
            UIAlertAction(
                title: String("Common.Cancel", table: .common), style: .cancel, handler: nil
            )
        )

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.viewContoller?.present(alertController, animated: true)
    }



    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.imagePicker(self.imagePickerController, didSelectImage: image)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerHandler: UIImagePickerControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        pickerController(picker, didSelect: image)
    }
}

// MARK: - UINavigationControllerDelegate
extension ImagePickerHandler: UINavigationControllerDelegate {

}
