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
    var returnDoneType:ZJJFormInputReturnDoneType = .none //设置点击return，要做的事，支持隐藏键盘和跳转到下一个输入框
    var placeholder:String = "" //输入框占位文本
    var verify:ZJJFormVerify = ZJJFormVerify() //校验输入框的类
    var isConsecutiveSpaces:Bool = false //是否连续空格，如果连续两个空格以上，会导致多出一个点代替空格
    var inputAccessoryView:UIView? 
}

