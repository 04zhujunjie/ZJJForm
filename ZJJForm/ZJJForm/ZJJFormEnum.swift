//
//  ZJJFormEnum.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//

import UIKit

enum ZJJFormCellStyle  {
    case `default`
    case option
    case value1
    case value2
    case input1
    case input2
    case textView1
    case textView2
    case customIdentifier(String) //自定义Cell的identifier
   
    func cellIdentifier() -> String {
        switch self {
        case .option:
            return kZJJFormTextViewOneCellIdentifier
        case .value1:
            return kZJJFormValueOneCellIdentifier
        case .value2:
            return kZJJFormValueTwoCellIdentifier
        case .input1:
            return kZJJFormInputOneCellIdentifier
        case .input2:
            return kZJJFormInputTwoCellIdentifier
        case.textView1:
            return kZJJFormTextViewOneCellIdentifier
        case.textView2:
            return kZJJFormTextViewTwoCellIdentifier
        case .customIdentifier(let identifier):
            return identifier
        default:
            return kZJJFormValueOneCellIdentifier
        }
    }
}

enum ZJJFormRequiredType {
    case none //非必须
    case required //必须
    case requiredAndStar //必须带红星
}

enum ZJJFormInputReturnDoneType {
    case none //
    case hiddenKeyboard //隐藏键盘
    case next //进入下一个输入框
}

enum ZJJFormInputErrorType {
    case none //不显示
    case line //显示下横线 ，就是横线变色
    case label //显示错误的信息
    case lineAndLabel //显示错误的信息和横线变色
}


enum ZJJFormInputVerifyType {
    case none 
    case editing //编辑的过程中进行验证，验证不通过，显示错误提示（可以继续输入）
    case stopEditing //编辑的过程中进行验证，验证不通过，禁止输入
    case endEdit //编辑结束后，在进行验证，验证不通过，显示错误提示
}


