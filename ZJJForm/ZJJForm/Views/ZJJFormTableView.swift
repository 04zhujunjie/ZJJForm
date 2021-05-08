//
//  ZJJFormTableView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/19.
//

import UIKit

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
