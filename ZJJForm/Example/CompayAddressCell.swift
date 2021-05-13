//
//  CustomCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/5/13.
//

import UIKit

typealias compayAddressCellBlock = (UITextField,CompayAddressInputModel)->()

class CompayAddressCell: ZJJFormTextViewBaseCell,UITextFieldDelegate {

    
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    private var selectCityBlock:compayAddressCellBlock?
    override func awakeFromNib() {
        super.awakeFromNib()
        cityTextField.delegate = self
        self.setFormTextViewCellSubView(keyLabel: self.keyLabel, textView: textView, errorLabel: errorLabel)
    }
    func selectCity(block:compayAddressCellBlock?) {
        self.selectCityBlock = block
    }
    
    
    override func updateFormInputCell(model: ZJJFormInputModel) {
        model.formUI.inputTextAlignment = .left
        super.updateFormInputCell(model: model)
        self.leftMarginConstraint.constant = model.formUI.lineLeftMargin
        self.rightMarginConstraint.constant = model.formUI.lineRightMargin
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            guard let compayAddressInputModel = self.formModel as? CompayAddressInputModel,let block = self.selectCityBlock else {
                return false
            }
            block(textField,compayAddressInputModel)
            return false
        }
        return true
    }
    
}
