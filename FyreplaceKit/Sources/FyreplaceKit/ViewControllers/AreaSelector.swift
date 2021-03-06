import RxCocoa
import RxSwift
import UIKit
import WildFyreKit

public class AreaSelector: NSObject {
    private var blur = UIVisualEffectView()
    private var picker = UIPickerView()
    private var pickerBottom: NSLayoutConstraint?
    private var pickerTop: NSLayoutConstraint?
    private var areas: [Area] = [] { didSet { picker.reloadAllComponents() } }
    private var disposer = DisposeBag()

    @IBOutlet
    public weak var delegate: AreaSelectorDelegate?
    @IBOutlet
    private var viewModel: AreaSelectorViewModel!

    public override init() {
        super.init()
        blur.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
    }

    public func createAreaPicker(inside view: UIView) {
        blur.effect = nil
        blur.isUserInteractionEnabled = false

        view.addSubview(blur)
        view.addSubview(picker)

        NSLayoutConstraint.activate([
            blur.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            blur.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blur.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        picker.alpha = 0
        pickerBottom = picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        pickerTop = picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerBottom!,
        ])

        guard let delegate = self.delegate else { return }

        viewModel.areas
            .retry(.exponentialDelayed(maxCount: .max, initial: 5, multiplier: 0.5))
            .fail(with: delegate)
            .subscribe(onNext: { areas in
                self.areas = areas

                if areas.count > 0 {
                    let index = areas.firstIndex { $0.name == self.viewModel.currentAreaName }
                    self.picker.isHidden = false
                    self.picker.selectRow(index ?? 0, inComponent: 0, animated: false)
                }
            })
            .disposed(by: disposer)

        viewModel.updateAreas()
    }

    public func destroyAreaPicker() {
        blur.removeFromSuperview()
        picker.removeFromSuperview()
        disposer = DisposeBag()
    }

    public func toggleAreaPicker() {
        let pickerWasVisible = pickerTop?.isActive ?? false
        let alpha: CGFloat = pickerWasVisible ? 0 : 1
        let blurEffect = pickerWasVisible ? nil : UIBlurEffect(style: .regular)

        blur.isUserInteractionEnabled = !pickerWasVisible
        pickerBottom?.isActive = pickerWasVisible
        pickerTop?.isActive = !pickerWasVisible
        delegate?.areaSelector?(self, pickerIsVisible: !pickerWasVisible)

        UIView.animate(withDuration: 0.3) {
            self.blur.effect = blurEffect
            self.picker.superview?.layoutIfNeeded()
            self.picker.alpha = alpha
        }
    }
}

extension AreaSelector: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = areas.count

        if count > 0, !areas.contains(where: { $0.name == viewModel.currentAreaName }) {
            viewModel.currentAreaName = areas[0].name
        }

        return count
    }
}

extension AreaSelector: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        areas[row].displayname
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.currentAreaName = areas[row].name
    }
}

@objc
public protocol AreaSelectorDelegate: FailureHandler {
    @objc
    optional func areaSelector(_ areaSelector: AreaSelector, pickerIsVisible: Bool)
}
