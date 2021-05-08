//
//  ZJJFormUI.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

fileprivate let kZJJFormUIMargin:CGFloat = 15

struct ZJJFormUI {
    var cellHeight:CGFloat = UITableView.automaticDimension //默认使用表格动态布局
    var cellSpace:CGFloat = 0 //cell与tableView两边的边距,左右的边距相等
    var isShowArrow:Bool = false //是否显示箭头>
    var isHiddenLine:Bool = false // 是否隐藏分割线，默认false
    var lineLeftMargin:CGFloat = kZJJFormUIMargin //分割线与左边的边距
    var lineHeight:CGFloat = 0.5 //分割线的高度
    var lineRightMargin:CGFloat = kZJJFormUIMargin //分割线与右边的边距
    var separatorLineColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.3)// 分割线颜色
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
