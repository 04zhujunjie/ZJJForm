//
//  ZJJFormBaseTableView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

class ZJJFormBaseTableView: UITableView {
    open   var dataArray:[ZJJFormModel] = []{
        didSet{
            //需要做延时，动态布局才显示正常
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.reloadData()
            }
        }
    }
    private var tapGesture:UITapGestureRecognizer?
    open var isTouchEndEditing:Bool = true{
        didSet{
            if let tap = self.tapGesture{
                if !isTouchEndEditing {
                    tap.removeTarget(self, action: #selector(touchesFormTableView))
                }
            }else{
                if isTouchEndEditing {
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(touchesFormTableView))
                    //设置tableView的响应事件的优先级，低于tableView上的子视图，不然协议无法点击
                    tap.cancelsTouchesInView = false
                    self.addGestureRecognizer(tap)
                    self.tapGesture = tap
                }
            }
            
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initFormBaseTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initFormBaseTableView()
    }
    
    private func initFormBaseTableView() {
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(formKeyboardWillShow(note:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        //监听键盘隐藏通知
        NotificationCenter.default.addObserver(self, selector: #selector(formKeyboardWillHidden(note:)), name:UIResponder.keyboardWillHideNotification,object: nil)
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.separatorColor = UIColor.clear
        self.estimatedRowHeight = 100
        self.estimatedSectionHeaderHeight = 0.01
        self.estimatedSectionFooterHeight = 0.01
        self.separatorStyle = .none
        self.isTouchEndEditing = false
        
    }
    
    @objc private func formKeyboardWillShow(note:NSNotification) {
        guard let userInfo = note.userInfo else {return}
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
        //获取动画执行的时间
        var duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if duration == nil { duration = 0.25 }
        self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    @objc private func formKeyboardWillHidden(note:NSNotification) {
        self.contentInset = UIEdgeInsets.zero
    }
    deinit {
        //取消键盘通知的监听
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func touchesFormTableView(){
        if self.isTouchEndEditing {
            self.endEditing(self.isTouchEndEditing)
        }
    }
    func formTableViewUpdates() {
        UIView.animate(withDuration: 0.1) {
            self.beginUpdates()
            self.endUpdates()
        }
    }
    
}
