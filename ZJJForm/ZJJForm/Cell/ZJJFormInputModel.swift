//
//  ZJJFormInputModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

class ZJJFormInputModel: ZJJFormBaseModel,ZJJFormBlockInputProtocol {
    
    var formValueBeginEditingBlock: ZJJFormInputBlock?
    var formValueChangeBlock: ZJJFormInputBlock?
    var formValueDidEndEditBlock: ZJJFormInputBlock?
    var formValueReturnBlock: ZJJFormInputBlock?
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
    var maxLength:Int = 255
    var isScrollEnabled:Bool = false //textView，当文字超过视图的边框时，是否允许滑动
    var keyboardType: UIKeyboardType = .default //输入键盘类型
    var returnKeyType:UIReturnKeyType = .default //return键的类型
    var placeholder:String = "" //输入框占位文本
    var verify:ZJJFormVerify = ZJJFormVerify() //校验输入框的类
    
}
