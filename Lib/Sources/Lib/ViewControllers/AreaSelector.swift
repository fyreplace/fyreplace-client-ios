import LibUtils
import LibWildFyre
import RxSwift
import RxCocoa
import UIKit

public class AreaSelector: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet
    private var viewModel: AreaSelectorViewModel!

    public weak var delegate: AreaSelectorDelegate? = nil
    private var picker: UIPickerView? = nil
    private var pickerBottom: NSLayoutConstraint? = nil
    private var areas: [Area] = []
    private var disposer = DisposeBag()

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        areas.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        areas[row].displayname
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setCurrentArea(name: areas[row].name)
    }

    public func createAreaPicker(inside view: UIView) {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        picker.alpha = 0
        view.addSubview(picker)

        let pickerBottom = picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerBottom,
        ])

        self.picker = picker
        self.pickerBottom = pickerBottom

        guard let delegate = self.delegate else { return }
        viewModel.areas.purify(with: delegate)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] areas in
                self.areas = areas
                picker.reloadAllComponents()
            })
            .disposed(by: disposer)

        viewModel.currentAreaIndex.purify(with: delegate)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { index in
                guard let i = index else { return }
                guard i != picker.selectedRow(inComponent: 0) else { return }
                picker.selectRow(i, inComponent: 0, animated: false)
            })
            .disposed(by: disposer)

        viewModel.updateAreas()
    }

    public func destroyAreaPicker() {
        picker?.removeFromSuperview()
        disposer = DisposeBag()
    }

    public func toggleAreaPicker() {
        guard let picker = picker else { return }
        guard let bottom = pickerBottom else { return }
        let offset = bottom.constant == 0 ? picker.frame.height : 0
        let alpha: CGFloat = offset == 0 ? 0 : 1

        bottom.constant = offset
        UIView.animate(withDuration: 0.3) {
            picker.superview?.layoutIfNeeded()
            picker.alpha = alpha
        }
    }
}

public protocol AreaSelectorDelegate: FailureHandler {
}
