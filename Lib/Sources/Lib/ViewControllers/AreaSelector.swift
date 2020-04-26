import LibUtils
import LibWildFyre
import RxSwift
import RxCocoa
import UIKit

public class AreaSelector: NSObject {
    @IBOutlet
    private var viewModel: AreaSelectorViewModel!

    public weak var delegate: AreaSelectorDelegate?
    private var blur = UIVisualEffectView()
    private var picker = UIPickerView()
    private var pickerBottom: NSLayoutConstraint?
    private var areas: [Area] = [] { didSet { picker.reloadAllComponents() } }
    private var disposer = DisposeBag()

    public override init() {
        super.init()
        blur.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        picker.alpha = 0
    }

    public func createAreaPicker(inside view: UIView) {
        view.addSubview(blur)
        view.addSubview(picker)

        blur.effect = nil
        blur.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            blur.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            blur.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blur.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        let pickerBottom = picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerBottom,
        ])

        self.pickerBottom = pickerBottom

        guard let delegate = self.delegate else { return }

        viewModel.areas.purify(with: delegate)
            .subscribe(onNext: { self.areas = $0 })
            .disposed(by: disposer)

        viewModel.currentAreaIndex.purify(with: delegate)
            .subscribe(onNext: { index in
                guard let i = index else { return }
                guard i != self.picker.selectedRow(inComponent: 0) else { return }
                self.picker.selectRow(i, inComponent: 0, animated: false)
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
        guard let bottom = pickerBottom else { return }
        let offset = bottom.constant == 0 ? picker.frame.height : 0
        let pickerVisible = offset == 0
        let alpha: CGFloat = pickerVisible ? 0 : 1
        let blurEffect = pickerVisible ? nil : UIBlurEffect(style: .regular)

        bottom.constant = offset
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
        areas.count
    }
}

extension AreaSelector: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        areas[row].displayname
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setCurrentArea(name: areas[row].name)
    }
}

// swiftlint:disable:next class_delegate_protocol
public protocol AreaSelectorDelegate: FailureHandler {
}
