//
//  ZJJTestModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/27.
//

import UIKit

class ZJJTestModel: NSObject,ZJJOptionProtocol {
    var jj_optionValue: String?
    var id:CGFloat?
}

class ZJJGenderModel:ZJJOptionProtocol{
    var genderId:Int = 0
    var jj_optionValue: String?{
        set{}
        get{
            if genderId == 0 {
                return "女"
            }else if genderId == 1{
                return "男"
            }else{
                return "未知"
            }
        }
    }
    init(id genderId:Int) {
        self.genderId = genderId
    }
}
