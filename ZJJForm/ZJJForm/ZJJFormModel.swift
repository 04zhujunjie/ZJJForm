//
//  ZJJFormModel.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//

import UIKit

class ZJJFormBaseModel : NSObject,ZJJFormBlockBaseProtocol {
    var formSelectCellBlock: ZJJFormBaseBlock?
    func formSelectCell(block:@escaping ZJJFormBaseBlock)  {
        self.formSelectCellBlock = block
    }
    var param:[String:Any?] = [:] //自定义携带的参数
    var formText:ZJJFormText = ZJJFormText()
    var formUI:ZJJFormUI = ZJJFormUI() //UI样式
    
}

class ZJJFormInputModel: ZJJFormBaseModel,ZJJFormBlockInputProtocol {
    
    var formValueBeginEditingBlock: ZJJFormInputBlock?
    var formValueChangeBlock: ZJJFormInputBlock?
    var formValueDidEndEditBlock: ZJJFormInputBlock?
    var formValueReturnBlock: ZJJFormInputBlock?
    func formValueBeginEditing(block: @escaping ZJJFormInputBlock) {
        self.formValueBeginEditingBlock = block
    }
    func formValueChange(block:@escaping ZJJFormInputBlock)  {
        self.formValueChangeBlock = block
    }
    func formValueDidEndEdit(block:@escaping ZJJFormInputBlock)  {
        self.formValueDidEndEditBlock = block
    }
    func formValueReturn(block: @escaping ZJJFormInputBlock) {
        self.formValueReturnBlock = block
    }
    var maxLength:Int = 255
    var isScrollEnabled:Bool = false //textView，当文字超过视图的边框时，是否允许滑动
    var keyboardType: UIKeyboardType = .default //输入键盘类型
    var returnKeyType:UIReturnKeyType = .default //return键的类型
    var placeholder:String = "" //输入框占位文本
    var verify:ZJJFormVerify = ZJJFormVerify() //校验输入框的类
    
}



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

class ZJJFormModel{
    var cellStyle:ZJJFormCellStyle = .default //cell的样式
    var model:ZJJFormBaseModel
    init(cellStyle:ZJJFormCellStyle,model:ZJJFormBaseModel) {
        self.cellStyle = cellStyle
        self.model = model
    }
}

fileprivate let kZJJFormUIMargin:CGFloat = 15

struct ZJJFormUI {
    var cellHeight:CGFloat = UITableView.automaticDimension //默认使用表格动态布局
    var cellSpace:CGFloat = 0 //cell与tableView两边的边距,左右的边距相等
    var isShowArrow:Bool = false //是否显示箭头>
    var isHiddenLine:Bool = false // 是否隐藏分割线，默认false
    var lineLeftMargin:CGFloat = kZJJFormUIMargin //分割线与左边的边距
    var lineHeight:CGFloat = 0.8 //分割线的高度
    var lineRightMargin:CGFloat = kZJJFormUIMargin //分割线与右边的边距
    var separatorLineColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.15)// 分割线颜色
    var errorFont:UIFont = .systemFont(ofSize: 12) //错误提示的字体大小
    var errorColor:UIColor = UIColor.red//错误的时候，错误提示的文本或线条的颜色
    var starColor:UIColor = UIColor.red //🌟的颜色
    var lineBreakMode :NSLineBreakMode = .byCharWrapping
    var keyTextColor:UIColor = .black //左边文本颜色
    var valueTextColor:UIColor = .black //右边边文本颜色
    var keyTextFont:UIFont = .systemFont(ofSize: 16) //左边文本字体的大小
    var valueTextFont:UIFont = .systemFont(ofSize: 16)  //右边文本字体的大小
    var placeholderColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.5)  //输入框的placeholder字体颜色
    var placeholderFont:UIFont = .systemFont(ofSize: 14)  //输入框的placeholder字体的大小
    var inputTextAlignment:NSTextAlignment = .right //输入框的文本对齐样式
}

struct ZJJFormText {
    var valueType:Int = 0
    var requiredType = ZJJFormRequiredType.none //是否必填
    var key:String = ""  //左边或上边文本
    var value:String = "" //右边值或者输入的
    var serviceKey:String = "" //后台字段key,方便通过serviceKey值，取对应的值
}


struct ZJJFormOption {
    var selectModel:Any? //选择的对象
    var optionArray:[Any] = [] //选择的列表
}

struct ZJJFormParam {
    var isValid:Bool = false
    var firstErrorMsg:String? //第一个错误的信息提示语
    var param:[String:Any?] = [:] //组装的参数
    var filterArray:[ZJJFormModel] = [] //筛选出来的对象
    init(dataArray:[ZJJFormModel],errorType:ZJJFormInputErrorType = .lineAndLabel,filterServiceKeys:[String] = [],filterValueTypes:[Int] = []) {
        var isPass = true
        for item in dataArray {
            if filterServiceKeys.contains(item.model.formText.serviceKey) || filterValueTypes.contains(item.model.formText.valueType) {
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
