//
//  ZJJFormInputBaseCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/21.
//

import UIKit

class ZJJFormInputBaseCell: ZJJFormBaseCell,ZJJFormBlockInputProtocol,ZJJFormInputCellProtocol{
    
    var formValueBeginEditingBlock:ZJJFormInputBlock?
    var formValueChangeBlock:ZJJFormInputBlock?
    var formValueDidEndEditBlock:ZJJFormInputBlock?
    var formValueReturnBlock: ZJJFormInputBlock?
    private var formErrorLabel: UILabel?
    private var formPlaceholderLabel:UILabel?
    private var formInputView:UIView?
    open var formInputModel: ZJJFormInputModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func formValueBeginEditing(block: @escaping ZJJFormInputBlock) {
        self.formValueBeginEditingBlock = block
    }
    func formValueChange(block:@escaping ZJJFormInputBlock)  {
        self.formValueChangeBlock = block
    }
    func formValueDidEndEdit(block:@escaping ZJJFormInputBlock)  {
        self.formValueDidEndEditBlock = block
    }
    
    func formValueReturn(block: @escaping ZJJFormInputBlock) {
        self.formValueReturnBlock = block
    }
    
    func setFormInputBaseCellSubView(keyLabel:UILabel?,formInputView:UIView? = nil,errorLabel:UILabel? = nil) {
        self.setFormBaseCellSubView(keyLabel: keyLabel, valueLabel: nil)
        self.formErrorLabel = errorLabel
        self.formInputView = formInputView
        if let formInput = formInputView {
            if let _ = formPlaceholderLabel {
                return
            }
            let placeholderString = "_placeholderLabel"
            if !formInput.getAllIvars().contains(placeholderString) {
                return
            }
            formPlaceholderLabel = UILabel.init()
            formPlaceholderLabel!.numberOfLines = 0
            formPlaceholderLabel!.sizeToFit()
            formPlaceholderLabel!.textAlignment = .right
            if let textField = formInput as? UITextField {
                textField.setValue(formPlaceholderLabel!, forKey: placeholderString)
            }else{
                formInput.addSubview(formPlaceholderLabel!)
                formInput.setValue(formPlaceholderLabel!, forKey: placeholderString)
            }
        }
    }
    
    func updateFormInputCell(model:ZJJFormInputModel){
        self.formInputModel = model
        self.updateFormCell(model: model)
        self.setFormInputView(model: model)
        self.setFormErrorView(model: model)
    }
    
    func setFormInputView(model:ZJJFormInputModel) {
        guard let inputView = self.formInputView else {
            return
        }
        if let textField = inputView as? UITextField {
            textField.textAlignment = model.formUI.inputTextAlignment
            textField.text = model.formText.value
            textField.keyboardType = model.keyboardType
            textField.returnKeyType = model.returnKeyType
            textField.textColor = model.formUI.valueTextColor
            textField.font = model.formUI.valueTextFont
        }else if let textView = inputView as? UITextView {
            textView.textAlignment = model.formUI.inputTextAlignment
            textView.text = model.formText.value
            textView.keyboardType = model.keyboardType
            textView.returnKeyType = model.returnKeyType
            textView.textColor = model.formUI.valueTextColor
            textView.font = model.formUI.valueTextFont
            textView.isScrollEnabled = model.isScrollEnabled
        }

        guard let label = self.formPlaceholderLabel else {
            return
        }
        label.font = model.formUI.placeholderFont
        label.textColor = model.formUI.placeholderColor
        label.text = model.placeholder
        label.textAlignment = model.formUI.inputTextAlignment
        
    }
    
    
    
    //设置错误提示
    func setFormErrorView(model:ZJJFormInputModel) {
        
        let errorType = model.verify.errorType
        if errorType == .label || errorType == .lineAndLabel {
            self.formErrorLabel?.isHidden = false
            if errorType == .lineAndLabel {
                self.formLineView.backgroundColor = model.formUI.errorColor
            }else{
                self.formLineView.backgroundColor = model.formUI.separatorLineColor
            }
            if let errorMsg = model.verify.errorMsg, errorMsg.count > 0 {
                self.formErrorLabel?.font = model.formUI.errorFont
                self.formErrorLabel?.textColor = model.formUI.errorColor
                self.formErrorLabel?.text = model.verify.errorMsg
            }else{
                self.formErrorLabel?.text = nil
            }
            
        }else if errorType == .line{
            self.formErrorLabel?.text = nil
            self.formErrorLabel?.isHidden = true
            self.formLineView.backgroundColor = model.formUI.errorColor
        }else{
            self.formErrorLabel?.text = nil
            self.formErrorLabel?.isHidden = true
            self.formLineView.backgroundColor = model.formUI.separatorLineColor
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ZJJFormInputBaseCell {
    
    @discardableResult //调用函数的时候忽略返回值，不会产生编译警告
    func setupVerifyValueBlock(type:ZJJFormInputVerifyType,value:String,model:ZJJFormInputModel) -> Bool {
        
        if let verifyValueBlock = model.verify.verifyValueBlock {
            let errorType = verifyValueBlock(value)
            if model.verify.type == type {
                if type == .stopEditing {
                    if errorType == .none {
                        return true
                    }else{
                        return false
                    }
                }else{
                    if type == .editing && value.count == 0 {
                        model.verify.errorType = .none
                    }else{
                        model.verify.errorType = errorType
                    }
                    self.setFormErrorView(model: model)
                }
                return false
            }
        }
        return true
    }
    
    //设置开始编辑的相关代理和回调
    func setupFormValueBeginEditing(value:String) -> Bool  {
        guard let model = self.formInputModel else {
            return false
        }
        if model.verify.isBeginEnditingHiddenError {
            model.verify.errorType = .none
            self.setFormErrorView(model: model)
        }
        self.setupVerifyValueBlock(type: .editing, value: value, model: model)
        if let delegate = self.delegate{
            delegate.formValueBeginEditing?(model:model , cell: self)
        }
        if let changeBlock = self.formValueBeginEditingBlock {
            changeBlock(model,self)
        }
        if let changeBlock = model.formValueBeginEditingBlock {
            changeBlock(model,self)
        }
        return true
    }
    
    func setupFormValueChange(value:String) {
        guard let model = self.formInputModel else {
            return
        }
        model.formText.value = value
        self.setupVerifyValueBlock(type: .editing, value: value, model: model)
        if let delegate = self.delegate{
            delegate.formValueChange?(model:model , cell: self)
        }
        if let block = self.formValueChangeBlock {
            block(model,self)
        }
        if let block = model.formValueChangeBlock {
            block(model,self)
        }
    }
    
    func setupFormValueDidEndEdit(value:String) {
        guard let model = self.formInputModel else {
            return
        }
        self.setupVerifyValueBlock(type: .endEdit, value: value, model: model)
        if let delegate = self.delegate{
            delegate.formValueDidEndEdit?(model:model , cell: self)
        }
        if let block = self.formValueDidEndEditBlock {
            block(model,self)
        }
        if let block = model.formValueDidEndEditBlock {
            block(model,self)
        }
    }
    
    func setupFormValueReturn() {
        guard let model = self.formInputModel else {
            return
        }
        if let delegate = self.delegate{
            delegate.formValueReturn?(model:model , cell: self)
        }
        if let block = self.formValueReturnBlock {
            block(model,self)
        }
        if let block = model.formValueReturnBlock {
            block(model,self)
        }
    }
    
    func inputView(_ inputView: UIView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        guard let model = self.formInputModel else {
            return false
        }
        
        var value = (inputView.value(forKey: "text") as? String) ?? ""
        //range.length == 0 表示正常输入，range.location表示当前输入的位置
        if range.length == 0 {
            //表示是正常输入或者粘贴
            value.insert(contentsOf: text, at: value.index(value.startIndex, offsetBy: range.location))

        }else{
            
            let start = value.index(value.startIndex, offsetBy: range.location)
            let end = value.index(value.startIndex, offsetBy: range.location+range.length-1)
            // 表示选中文本，进行输入替换
            value.replaceSubrange(start...end, with: text)
        }
//        print("--\(value)-\(range)---")
        if value.count > model.maxLength {
            if value.count - model.maxLength > 1 {
                //说明是粘贴多个文本，超出最大个数，截取前面的最大个数，进行验证，验证通过进行赋值
                let textValue = "\(value.prefix(model.maxLength))"
                if self.setupVerifyValueBlock(type: .stopEditing, value: textValue, model: model) {
                    inputView.setValue(textValue, forKey: "text")
                    model.formText.value = textValue
                }
            }
            return false
        }
        return self.setupVerifyValueBlock(type: .stopEditing, value: value, model: model)
    }
}
