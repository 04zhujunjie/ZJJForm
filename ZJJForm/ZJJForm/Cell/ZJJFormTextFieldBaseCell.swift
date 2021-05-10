//
//  ZJJFormTextFieldBaseCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/23.
//

import UIKit

class ZJJFormTextFieldBaseCell: ZJJFormInputBaseCell {

    private var formTextField: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setFormTextFieldCellSubView(keyLabel:UILabel?,textField:UITextField? = nil,errorLabel:UILabel? = nil) {
        self.setFormInputBaseCellSubView(keyLabel: keyLabel,formInputView: textField, errorLabel: errorLabel)
        self.formTextField = textField
        if let tf = textField {
            tf.delegate = self
            tf.rightViewMode = .always
        }
        
    }
    
    
  override  func updateFormInputCell(model:ZJJFormInputModel){
    super.updateFormInputCell(model: model)
    self.setFormTextField(model: model)
        
    }
    
   private  func setFormTextField(model:ZJJFormInputModel) {
        guard let textField = self.formTextField else {
            return
        }
        let rightView = UIView()
        if model.formUI.isShowArrow {
            let rightViewWidth:CGFloat = 15
            rightView.frame = CGRect.init(x: 0, y: 0, width:rightViewWidth, height: textField.frame.size.height)
            let arrowImageViewWidth = self.formArrowImageView.frame.size.width
            formArrowImageView.center = CGPoint.init(x:rightViewWidth - arrowImageViewWidth/2.0, y: rightView.frame.size.height/2.0)
            rightView.addSubview(self.formArrowImageView)
        }
        textField.rightView = rightView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ZJJFormTextFieldBaseCell:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let value = formTextField?.text ?? ""
        return self.setupFormValueBeginEditing(value:value)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = formTextField?.text ?? ""
        self.setupFormValueDidEndEdit(value:value)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let value = textField.text ?? ""
        self.setupFormValueChange(value:value)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 0 && string != "\n"  {
            return self.inputView(textField, shouldChangeTextIn: range, replacementText: string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setupFormValueReturn()
        return true
    }
}
