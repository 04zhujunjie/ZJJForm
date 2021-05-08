//
//  ZJJFormVerify.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

class ZJJFormVerify {
    var errorType:ZJJFormInputErrorType = .none //显示出错的信息类型
    var isBeginEnditingHiddenError:Bool = true //如果有错误提示，是否开始的编辑的时候就隐藏错误提示，true表示隐藏，false表示显示
    var errorMsg:String? //错误的信息提示
    fileprivate(set)   var type:ZJJFormInputVerifyType = .none //验证类型，在什么情况下进行验证
    var verifyValueBlock:ZJJFormInputVerifyValueBlock? //验证回调
    
    init(type:ZJJFormInputVerifyType = .none,errorMsg: String? = nil, verifyValueBlock:ZJJFormInputVerifyValueBlock? = nil){
        self.errorMsg = errorMsg
        self.type = type
        self.verifyValueBlock = verifyValueBlock
    }
}
