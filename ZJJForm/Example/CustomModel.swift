//
//  CustomModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/5/13.
//

import UIKit

class AreaModel:ZJJOptionProtocol {
    var jj_optionValue: String?
    var id:Int = 0
    
    init(optionValue:String,id:Int) {
        self.jj_optionValue = optionValue
        self.id = id
    }
    
}

class CompayAddressInputModel: ZJJFormInputModel {
    var option:ZJJOption = ZJJOption()
}

