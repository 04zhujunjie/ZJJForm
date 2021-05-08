//
//  ZJJFormText.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

struct ZJJFormText {
    
    var requiredType = ZJJFormRequiredType.none //是否必填
    var key:String = ""  //左边或上边文本
    var value:String = "" //右边值或者输入的
    var serviceKey:String = "" //后台字段key,方便通过serviceKey值，取对应的值
}
