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


extension ZJJFormTableView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.section].list[indexPath.row]
        let identifier = model.cellStyle.cellIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        self.setFormEditCellDelegate(model: model.model, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.section].list[indexPath.row]
        return model.model.formUI.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = self.dataArray[section]
        if let title = model.title, title.count > 0 {
            return 30
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = self.dataArray[section]
        return model.title
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    
}
