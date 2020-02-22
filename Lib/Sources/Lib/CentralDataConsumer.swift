import UIKit

public protocol CentralDataConsumer: UIViewController {
    var centralViewModel: CentralViewModel! { get set }
}
