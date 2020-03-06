import LibWildFyre
import UIKit

public typealias ImageSelectorController = UIViewController & ImageSelectorDelegate

public class ImageSelector: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private weak var controller: ImageSelectorController?

    public init(with viewController: ImageSelectorController) {
        controller = viewController
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller?.dismiss(animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { controller?.dismiss(animated: true) }
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        let url = info[.imageURL] as? NSURL

        DispatchQueue.global(qos: .userInitiated).async {
            self.extractImageData(image: image, isPng: url?.pathExtension == "png")
        }
    }

    public func selectImage() {
        let choice = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionsData: [String: UIImagePickerController.SourceType?] = [
            "library": .photoLibrary,
            "camera": .camera,
            "cancel": nil,
        ]

        for data in actionsData {
            let action = UIAlertAction(
                title: NSLocalizedString("Lib.ImageSelector.chooseSource.action.\(data.key)", comment: ""),
                style: data.value != nil ? .default : .cancel,
                handler: { action in
                    guard let source = data.value else { return }
                    self.selectImage(from: source)
                }
            )

            choice.addAction(action)
        }

        controller?.present(choice, animated: true)
    }

    private func selectImage(from source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        controller?.present(picker, animated: true)
    }

    private func extractImageData(image: UIImage, isPng: Bool) {
        guard var data = isPng ? image.pngData() : image.jpegData(compressionQuality: 1.0) else { return }
        let ext = isPng ? "png" : "jpg"
        let mime = "image/" + (isPng ? "png" : "jpeg")

        if data.count >= MAX_IMAGE_SIZE {
            guard let newData = image.downscaled()?.jpegData(compressionQuality: 0.5) else { return }
            data = newData
        }

        guard data.count < MAX_IMAGE_SIZE else {
            let alert = UIAlertController(
                title: NSLocalizedString("Lib.ImageSelector.sizeError.title", comment: ""),
                message: NSLocalizedString("Lib.ImageSelector.sizeError.message", comment: ""),
                preferredStyle: .alert
            )
            let ok = UIAlertAction(
                title: NSLocalizedString("Lib.ImageSelector.sizeError.action.ok", comment: ""),
                style: .default
            )

            alert.addAction(ok)
            controller?.present(alert, animated: true)
            return
        }

        DispatchQueue.main.async {
            self.controller?.image(selected: ImageData(name: "image.\(ext)", mime: mime, data: data))
        }
    }
}

public protocol ImageSelectorDelegate {
    func image(selected imageData: ImageData)
}

private extension UIImage {
    func downscaled() -> UIImage? {
        let factor = (size.width * size.height * scale) / CGFloat(MAX_IMAGE_AREA)

        if factor <= 1 {
            return self
        }

        let newWidth = size.width / factor
        let newHeight = size.height / factor
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

private let MAX_IMAGE_SIZE = 1024 * 1024
private let MAX_IMAGE_AREA = 1920 * 1080
