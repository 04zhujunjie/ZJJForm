//
//  ZJJFormBaseTableView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/26.
//

import UIKit

class ZJJFormBaseTableView: UITableView,ZJJFormEditCellDelegate {
 
    open   var dataArray:[ZJJFormSectionModel] = []{
        didSet{
            //需要做延时，动态布局才显示正常
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.reloadData()
            }
        }
    }
    private var formContentInset:UIEdgeInsets = .zero
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
        self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        self.formContentInset = self.contentInset
    }
    @objc private func formKeyboardWillHidden(note:NSNotification) {
        self.contentInset = UIEdgeInsets.zero
    }
    deinit {
        //取消键盘通知的监听
        NotificationCenter.default.removeObserver(self)
    }
    
    func setFormEditCellDelegate(model:ZJJFormBaseModel,cell:UITableViewCell)  {
        if var inputCell = cell as? ZJJFormInputCellProtocol {
            if let inputModel = model as? ZJJFormInputModel {
                inputCell.updateFormInputCell(model:inputModel)
                inputCell.delegate = self
            }
        }else if var baseCell = cell as? ZJJFormCellBaseProtocol{
            baseCell.updateFormCell(model: model)
            baseCell.delegate = self
        }
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
    
    func formSelectCell(model:ZJJFormBaseModel,cell:UITableViewCell){
        if self.isTouchEndEditing {
            //隐藏键盘
            self.endEditing(true)
        }
    }
    
    func formValueBeginEditing(model: ZJJFormInputModel, cell: UITableViewCell) {
        self.verifyUpdates(model: model,cell: cell)
    }

    func formValueChange(model: ZJJFormInputModel, cell: UITableViewCell) {
        self.verifyUpdates(model: model,cell: cell)
    }

    func formValueDidEndEdit(model: ZJJFormInputModel, cell: UITableViewCell) {
        self.verifyUpdates(model: model,cell: cell)
    }

    func formValueReturn(model: ZJJFormInputModel, cell: UITableViewCell) {
        self.setReturnDone(model: model)
    }
    
    func verifyUpdates(model: ZJJFormInputModel,cell: UITableViewCell) {
        
        if let _ = cell as? ZJJFormTextViewBaseCell {
            //说明是textView输入，需要时时更新表格，才能达到自动布局
            self.formTableViewUpdates()
        }else{
            if model.verify.verifyValueBlock != nil {
                self.formTableViewUpdates()
            }
        }
    }
    
    func setReturnDone(model: ZJJFormInputModel)  {
        if model.returnDoneType == .hiddenKeyboard {
            self.endEditing(true)
        }else if model.returnDoneType == .next{
            if let indexPath = self.formInputNextCell(model: model),let cell = self.cellForRow(at: indexPath) {
                self.formInputBecomeFirstResponder(view: cell)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }else{
                self.endEditing(true)
            }
        }
    }
    
    //设置响应的输入框
    private func formInputBecomeFirstResponder(view:UIView) {
        for subView in view.subviews {
            if let textField = subView as? UITextField {
                textField.becomeFirstResponder()
            }else if  let textView = subView as? UITextView {
                textView.becomeFirstResponder()
            }else{
                self.formInputBecomeFirstResponder(view: subView)
            }
        }
    }
    
    //查找下个有输入框的UITableViewCell
    private  func formInputNextCell(model:ZJJFormInputModel) -> IndexPath? {
        var nextIndex:Int = -1
        var currentIndex:Int = -1
        for (section,sectionItem) in dataArray.enumerated() {
            for (index,item) in sectionItem.list.enumerated() {
                if item.model == model {
                    currentIndex = index
                }
                if currentIndex > -1 && index > currentIndex&&item.model.isKind(of: ZJJFormInputModel.self) {
                    nextIndex = index
                    break
                }
            }
            if sectionItem.list.count > nextIndex && nextIndex > -1 {
                let indexPath = IndexPath.init(row: nextIndex, section: section)
                return indexPath
            }
        }
        
        return nil
    }
    
}
