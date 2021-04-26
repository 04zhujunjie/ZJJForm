//
//  ZJJFormTextViewBaseCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/23.
//

import UIKit

class ZJJFormTextViewBaseCell: ZJJFormInputBaseCell {
    
    private var formTextView: UITextView?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFormTextViewCellSubView(keyLabel:UILabel?,textView:UITextView? = nil,errorLabel:UILabel? = nil) {
        self.setFormInputBaseCellSubView(keyLabel: keyLabel,formInputView: textView, errorLabel: errorLabel)
        self.formTextView = textView
        if let tv = textView {
            tv.delegate = self
        }
        
    }
    
    override  func updateFormInputCell(model:ZJJFormInputModel){
        super.updateFormInputCell(model: model)
    }
    
}

extension ZJJFormTextViewBaseCell:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.setupFormValueBeginEditing(value: textView.text)
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.setupFormValueChange(value: textView.text)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.setupFormValueDidEndEdit(value: textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 0 {
            if text == "\n" {
                self.setupFormValueReturn()
                return false
            }
            return self.inputView(textView, shouldChangeTextIn: range, replacementText: text)
        }
        return true
    }
    
}
