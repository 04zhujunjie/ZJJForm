//
//  ZJJFormConstant.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/19.
//
import UIKit

//只能输入英文和空格
public let kZJJOnlySpaceAndEnglishRegex = "^[a-zA-Z / s]+$"
//检验邮箱的正则表达
public let kZJJEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

typealias ZJJFormInputVerifyValueBlock = (String) -> (ZJJFormInputErrorType)
typealias ZJJFormBaseBlock = (ZJJFormBaseModel,UITableViewCell)->()
typealias ZJJFormInputBlock = (ZJJFormInputModel,UITableViewCell)->()


public let kZJJFormValueOneCellIdentifier = "ZJJFormValueOneCell"
public let kZJJFormValueTwoCellIdentifier = "ZJJFormValueTwoCell"
public let kZJJFormInputOneCellIdentifier = "ZJJFormInputOneCell"
public let kZJJFormInputTwoCellIdentifier = "ZJJFormInputTwoCell"
public let kZJJFormTextViewOneCellIdentifier = "ZJJFormTextViewOneCell"
public let kZJJFormTextViewTwoCellIdentifier = "ZJJFormTextViewTwoCell"


