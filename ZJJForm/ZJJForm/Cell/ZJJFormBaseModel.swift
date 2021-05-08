//
//  ZJJFormBaseModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

class ZJJFormBaseModel : NSObject,ZJJFormBlockBaseProtocol {
    var formSelectCellBlock: ZJJFormBaseBlock?
    func formSelectCell(block:@escaping ZJJFormBaseBlock)  {
        self.formSelectCellBlock = block
    }
    var valueType:Int = 0 //自定义标识
    var param:[String:Any?] = [:] //自定义携带的参数
    var formText:ZJJFormText = ZJJFormText()
    var formUI:ZJJFormUI = ZJJFormUI() //UI样式
}
