//
//  ZJJPopupModel.swift
//  ZJJPopup
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

struct ZJJPopupModel {
    
    var animationType:ZJJPopupAnimationType = .move //弹框出现样式
    var showInType:ZJJPopupViewShowInType = .window //弹框添加到哪里，默认是在window上
    var popupViewRadius:CGFloat = 10 //设置popupView的圆角
    var isTouchHidden:Bool = true //点击遮罩层，是否隐藏弹框视图
    var isConfirmHidden:Bool = true //点击确定按钮，是否隐藏弹框视图
    var contentViewMinHeight:CGFloat = 220 //contentView内容的最小高度
    var maskLayerColor:UIColor = UIColor.init(red:0, green: 0, blue:0, alpha: 0.5) //遮罩层的颜色
    var blurEffectStyle:ZJJBlurEffectStyle = .none //设置毛玻璃效果,设置为none，显示遮罩层的颜色
    var backgroundColor:UIColor = .white{
        didSet{
            self.topViewConfig.backgroundColor = backgroundColor
        }
    } //背景颜色
    
    var topViewConfig:ZJJPopupTopViewConfig = ZJJPopupTopViewConfig() //topVie配置
    static func popup(title:String,animationType:ZJJPopupAnimationType = .move) -> ZJJPopupModel {
        var model = ZJJPopupModel()
        model.topViewConfig.titleConfig.text = title
        model.animationType = animationType
        return model
    }
    
    static func popupCenter(isTouch isTouchHidden:Bool = false,minHeight contentViewMinHeight:CGFloat = 220) -> ZJJPopupModel {
        var model = ZJJPopupModel()
        model.isTouchHidden = isTouchHidden
        model.animationType = .scale
        model.contentViewMinHeight = contentViewMinHeight //设置最小高度
        model.topViewConfig.isHidden = true //隐藏topView
        return model
    }
    
}

class ZJJPopupTopViewConfig{
    var isHidden:Bool = false //是否隐藏
    var backgroundColor:UIColor = .white
    var minHeight:CGFloat = 48 //最小高度
    var isTitleAutomaticCenter:Bool = true //标题是否自动居中，true表示title的宽度=supview.width - max(cancel.width ,confirm.width)*2,并且居中显示,fasle 表示 title的宽度=supview.width-(显示按钮的宽度)，不一定居中显示
    //分割线设置
    var  separatorConfig:ZJJPopupSeparatorConfig = ZJJPopupSeparatorConfig()
    var titleConfig:ZJJPopupUIConfig = ZJJPopupUIConfig() //标题的设置
    var cancelConfig:ZJJPopupButtonConfig = ZJJPopupButtonConfig.init(text: "取消") //取消按钮设置
    var confirmConfig:ZJJPopupButtonConfig = ZJJPopupButtonConfig.init(text: "确定") //确定按钮设置
    init(isHidden:Bool = false,minHeight:CGFloat = 48,isTitleAutomaticCenter:Bool = true) {
        self.isHidden = isHidden
        self.minHeight = minHeight
        self.isTitleAutomaticCenter = isTitleAutomaticCenter
    }
}

class ZJJPopupSeparatorConfig {
    var color:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.3) //分割线的颜色
    var height:CGFloat = 0.5 //分割线的高度
    var isHidden:Bool = false //是否隐藏分割线
}

class ZJJPopupButtonConfig: ZJJPopupUIConfig {
    var margin:CGFloat = 8 //按钮距离父视图的左边或右边距离,如果按钮在左边，那么就是距离父视图的左边距，如果按钮在右边，那么就是距离俯视图的右边距
    var maxWidth:CGFloat = 80 //按钮的最大宽度，如果文本过长，超过最大宽度，那么按钮的宽度为maxWidth，会根据numberOfLines属性来计算文本是否换行
    var minTopBottom:CGFloat = 8 //按钮距离父视图的上下边的最小边距
    open class var  halfRadius: CGFloat {
        get {
            return -1
        }
    } //圆角等于按钮高度的一半的参数
}


class  ZJJPopupUIConfig{
    
    var text:String = ""
    var isHidden:Bool = false
    var font:UIFont = .systemFont(ofSize: 16)
    var color:UIColor = .black
    var numberOfLines:Int = 0
    var backgroundColor:UIColor = .clear
    var textAlignment:NSTextAlignment = .center
    var leftRightMargin:CGFloat = 10 //文本的左右边距
    var borderWidth:CGFloat = 0
    var borderColor:UIColor = UIColor.clear
    var cornerRadius:CGFloat = 0
    var masksToBounds:Bool = false
    
    init(text:String = "") {
        self.text = text
    }
    
    func set(cornerRadius:CGFloat = 0,borderWidth:CGFloat = 0,borderColor:UIColor = UIColor.clear) {
        self.masksToBounds = true
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }
    
}
