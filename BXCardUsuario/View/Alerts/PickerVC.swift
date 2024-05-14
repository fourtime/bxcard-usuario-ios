//
//  PickerVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - PickerDelegate Protocol
protocol PickerDelegate {
    func didConfirmSelection(data: PickerData, withId id: String)
    func didCancelSelection(withId id: String)
}


// MARK: - PickerData Protocol
protocol PickerData {
    var pickerRowTitle: String { get }
}


class PickerVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var pvPicker: UIPickerView!
    @IBOutlet weak var vwToolbar: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwBackground: UIView!
    
    // MARK: - Properties
    var delegate: PickerDelegate?
    var dataArray: [PickerData]?
    var dataId: String?
    var dataSelected: PickerData?
    var dataAlreadySelected: PickerData?
    var toolbarColor: UIColor?
    var cancelButtonTitleColor: UIColor?
    var cancelButtonBackgroundColor: UIColor?
    var selectButtonTitleColor: UIColor?
    var selectButtonBackgroundColor: UIColor?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let alreadySelected = dataAlreadySelected, let row = dataArray?.firstIndex(where: { $0.pickerRowTitle == alreadySelected.pickerRowTitle }) {
            pvPicker.selectRow(row, inComponent: 0, animated: false)
            
        } else if let dataArray = dataArray, dataArray.count > 0, dataSelected == nil {
            dataSelected = dataArray[0]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwBackground.backgroundColor = UIColor.alertTransparentBackground
        vwToolbar.backgroundColor = toolbarColor
        
        btnCancel.setTitleColor(cancelButtonTitleColor, for: UIControl.State())
        btnCancel.backgroundColor = cancelButtonBackgroundColor
        
        btnSelect.setTitleColor(selectButtonTitleColor, for: UIControl.State())
        btnSelect.backgroundColor = selectButtonBackgroundColor
        
        pvPicker.backgroundColor = UIColor.pickerBackground
    }
    
    // MARK: - IBActions
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        dismiss(animated: false) {
            self.delegate?.didCancelSelection(withId: self.dataId ?? "")
        }
    }
    
    @IBAction func didPressSelectButton(_ sender: UIButton) {
        dismiss(animated: false) {
            self.delegate?.didConfirmSelection(data: self.dataSelected!, withId: self.dataId ?? "")
        }
    }
    
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension PickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (dataArray?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray?[row].pickerRowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataSelected = dataArray?[row]
    }
    
}


