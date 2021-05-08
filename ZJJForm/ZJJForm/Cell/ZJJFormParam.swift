//
//  ZJJFormParam.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

struct ZJJFormParam {
    var isValid:Bool = false
    var firstErrorMsg:String? //第一个错误的信息提示语
    var param:[String:Any?] = [:] //组装的参数
    var filterArray:[ZJJFormModel] = [] //筛选出来的对象
    init(dataArray:[ZJJFormModel],errorType:ZJJFormInputErrorType = .lineAndLabel,filterServiceKeys:[String] = [],filterValueTypes:[Int] = []) {
        var isPass = true
        for item in dataArray {
            if filterServiceKeys.contains(item.model.formText.serviceKey) || filterValueTypes.contains(item.model.valueType) {
                self.filterArray.append(item)
            }else{
                let formText = item.model.formText
                //必填信息，但是有没有值
                if formText.requiredType != .none && formText.value.count == 0 {
                    if isPass {
                        //设置不通过
                        isPass = false
                    }
                    if let formInput = item.model as? ZJJFormInputModel {
                        formInput.verify.errorType = errorType
                        if let errorMsg = formInput.verify.errorMsg,errorMsg.count > 0 && self.firstErrorMsg == nil {
                            //获取第一个错误的提示信息
                            self.firstErrorMsg = formInput.verify.errorMsg
                        }
                    }
                }
                let serviceKey = formText.serviceKey
                if serviceKey.count > 0  {
                    self.param[serviceKey] = formText.value
                }

            }
        }
        self.isValid = isPass
        if !isPass {
            self.param = [:]
        }
    }
    
    
}
