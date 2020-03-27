import UIKit

public extension UIViewController {
    func retrieveTraitCollection() -> UITraitCollection {
        let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        let isPortrait = view.bounds.width < view.bounds.height
        let traits = [
            UITraitCollection(horizontalSizeClass: isPhone ? .compact : .regular),
            UITraitCollection(verticalSizeClass: isPortrait ? .regular : .compact)
        ]

        return UITraitCollection(traitsFrom: traits)
    }
}
