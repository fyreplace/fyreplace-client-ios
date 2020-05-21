import LibUtils
import LibWildFyre
import UIKit

public typealias ImageSelectorController = UIViewController & ImageSelectorDelegate

public class ImageSelector: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    fileprivate static let maxImageArea = 1920 * 1080

    public weak var delegate: ImageSelectorController?

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.dismiss(animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        defer { delegate?.dismiss(animated: true) }
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        let url = info[.imageURL] as? NSURL

        DispatchQueue.global(qos: .userInitiated).async {
            self.extractImageData(image: image, isPng: url?.pathExtension == "png")
        }
    }

    public func selectImage() {
        let choice = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionsData: [(String, UIImagePickerController.SourceType?)] = [
            ("library", .photoLibrary),
            ("camera", .camera),
            ("cancel", nil),
        ]

        for (name, source) in actionsData {
            let action = UIAlertAction(
                title: .tr("Lib.ImageSelector.chooseSource.action.\(name)"),
                style: source != nil ? .default : .cancel,
                handler: { _ in
                    guard let source = source else { return }
                    self.selectImage(from: source)
                }
            )

            choice.addAction(action)
        }

        delegate?.present(choice, animated: true)
    }

    private func selectImage(from source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        delegate?.present(picker, animated: true)
    }

    private func extractImageData(image: UIImage, isPng: Bool) {
        guard var data = isPng ? image.pngData() : image.jpegData(compressionQuality: 1.0) else { return }
        let ext = isPng ? "png" : "jpg"
        let mime = "image/" + (isPng ? "png" : "jpeg")
        let maxBytes = delegate?.maxImageBytes ?? 0

        if data.count >= maxBytes {
            guard let newData = image.downscaled()?.jpegData(compressionQuality: 0.5) else { return }
            data = newData
        }

        guard data.count < maxBytes else {
            let alert = UIAlertController(
                title: .tr("Lib.ImageSelector.sizeError.title"),
                message: .tr("Lib.ImageSelector.sizeError.message"),
                preferredStyle: .alert
            )
            let ok = UIAlertAction(
                title: .tr("Lib.ImageSelector.sizeError.action.ok"),
                style: .default
            )

            alert.addAction(ok)
            delegate?.present(alert, animated: true)
            return
        }

        DispatchQueue.main.async {
            self.delegate?.imageSelector(self, didSelectImage: ImageData(name: "image.\(ext)", mime: mime, data: data))
        }
    }
}

public protocol ImageSelectorDelegate: AnyObject {
    static var maxImageSize: Float { get }

    func imageSelector(_ imageSelector: ImageSelector, didSelectImage image: ImageData)
}

private extension ImageSelectorDelegate {
    var maxImageBytes: Int { Int(Self.maxImageSize * 1024 * 1024) }
}

private extension UIImage {
    func downscaled() -> UIImage? {
        let factor = (size.width * size.height * scale) / CGFloat(ImageSelector.maxImageArea)

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
