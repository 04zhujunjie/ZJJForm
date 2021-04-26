//
//  ZJJFormTableView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/19.
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



class ZJJFormTableView: ZJJFormBaseTableView {
    
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.registerFormCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerFormCell() {
        
        self.delegate = self
        self.dataSource = self
        self.register(UINib.init(nibName: kZJJFormValueOneCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormValueOneCellIdentifier)
        self.register(UINib.init(nibName: kZJJFormValueTwoCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormValueTwoCellIdentifier)
        self.register(UINib.init(nibName: kZJJFormInputOneCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormInputOneCellIdentifier)
        self.register(UINib.init(nibName: kZJJFormInputTwoCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormInputTwoCellIdentifier)
        self.register(UINib.init(nibName: kZJJFormTextViewOneCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormTextViewOneCellIdentifier)
        self.register(UINib.init(nibName: kZJJFormTextViewTwoCellIdentifier, bundle: nil), forCellReuseIdentifier: kZJJFormTextViewTwoCellIdentifier)
       
    }
}


extension ZJJFormTableView:UITableViewDataSource,UITableViewDelegate,ZJJFormEditCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row]
        let identifier = model.cellStyle.cellIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if var inputCell = cell as? ZJJFormInputCellProtocol {
            if let inputModel = model.model as? ZJJFormInputModel {
                inputCell.updateFormInputCell(model:inputModel)
                inputCell.delegate = self
            }
        }else if var baseCell = cell as? ZJJFormCellBaseProtocol{
            baseCell.updateFormCell(model: model.model)
            baseCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.row]
        return model.model.formUI.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
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
        
    }
    
     private func verifyUpdates(model: ZJJFormInputModel,cell: UITableViewCell) {
        
        if let _ = cell as? ZJJFormTextViewBaseCell {
            //说明是textView输入，需要时时更新表格，才能达到自动布局
            self.formTableViewUpdates()
        }else{
            if model.verify.verifyValueBlock != nil {
                self.formTableViewUpdates()
            }
        }
    }
}
