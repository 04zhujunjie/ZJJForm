//
//  ZJJFormInputTwoCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/19.
//

import UIKit

class ZJJFormInputTwoCell: ZJJFormTextFieldBaseCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFormTextFieldCellSubView(keyLabel: keyLabel, textField: textField, errorLabel: errorLabel)
    }
    
    override func updateFormInputCell(model: ZJJFormInputModel) {
        super.updateFormInputCell(model: model)
        textField.textAlignment = .left
        self.leftMarginConstraint.constant = model.formUI.lineLeftMargin
        self.rightMarginConstraint.constant = model.formUI.lineRightMargin
    }
    
    
}
