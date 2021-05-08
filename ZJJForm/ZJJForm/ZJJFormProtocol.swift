//
//  ZJJFormProtocol.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//
import UIKit


@objc protocol ZJJFormEditCellBaseDelegate:NSObjectProtocol{
    @objc optional func formSelectCell(model:ZJJFormBaseModel,cell:UITableViewCell)
}

@objc protocol ZJJFormEditCellDelegate:ZJJFormEditCellBaseDelegate{
    @objc optional func formValueBeginEditing(model:ZJJFormInputModel,cell:UITableViewCell)
    @objc optional func formValueChange(model:ZJJFormInputModel,cell:UITableViewCell)
    @objc optional func formValueDidEndEdit(model:ZJJFormInputModel,cell:UITableViewCell)
    @objc optional func formValueReturn(model:ZJJFormInputModel,cell:UITableViewCell)
}


protocol ZJJFormCellBaseProtocol {
    var delegate:ZJJFormEditCellDelegate?{set get}
    func updateFormCell(model:ZJJFormBaseModel)
}

protocol ZJJFormInputCellProtocol:ZJJFormCellBaseProtocol {
    func updateFormInputCell(model:ZJJFormInputModel)
}

protocol ZJJFormBlockBaseProtocol{
    var formSelectCellBlock:ZJJFormBaseBlock?{set get}
    mutating func formSelectCell(block:@escaping ZJJFormBaseBlock)
}


protocol ZJJFormBlockInputProtocol:ZJJFormBlockBaseProtocol {
    var formValueBeginEditingBlock:ZJJFormInputBlock?{set get}
    var formValueChangeBlock:ZJJFormInputBlock?{set get}
    var formValueDidEndEditBlock:ZJJFormInputBlock?{set get}
    var formValueReturnBlock:ZJJFormInputBlock?{set get}
    mutating func formValueBeginEditing(block:@escaping ZJJFormInputBlock)
    mutating func formValueChange(block:@escaping ZJJFormInputBlock)
    mutating  func formValueDidEndEdit(block:@escaping ZJJFormInputBlock)
    mutating  func formValueReturn(block:@escaping ZJJFormInputBlock)
}

