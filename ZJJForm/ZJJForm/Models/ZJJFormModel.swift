//
//  ZJJFormModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//

import UIKit

class ZJJFormModel{
    var cellStyle:ZJJFormCellStyle = .default //cell的样式
    var model:ZJJFormBaseModel
    init(cellStyle:ZJJFormCellStyle,model:ZJJFormBaseModel) {
        self.cellStyle = cellStyle
        self.model = model
    }
}

