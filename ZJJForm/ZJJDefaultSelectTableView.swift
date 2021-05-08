//
//  ZJJDefaultSelectTableView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/28.
//

import UIKit

typealias ZJJDefaultSelectTableViewCellForRowBlock = (UITableView,IndexPath,ZJJOptionProtocol,ZJJOptionProtocol?) -> UITableViewCell?

typealias ZJJDefaultSelectTableViewHeightForRowBlock = (UITableView,IndexPath,ZJJOptionProtocol) -> CGFloat?

class ZJJDefaultSelectTableView: UITableView {

    private var selectIndex:Int = -1
    open var selectModel:ZJJOptionProtocol?
    var separatorLeftRightMargin:CGFloat = 15{
        didSet{
            self.separatorInset = UIEdgeInsets.init(top: 0, left: separatorLeftRightMargin, bottom: 0, right: separatorLeftRightMargin)
        }
    }
    private var cellForRowBlock:ZJJDefaultSelectTableViewCellForRowBlock?
    private var heightForRowBlock:ZJJDefaultSelectTableViewHeightForRowBlock?
    var model:ZJJOption = ZJJOption(){
        didSet{
            self.reloadData()
        }
    }

    convenience init(frame: CGRect, model:ZJJOption) {
        self.init(frame: frame, style: .plain)
        self.model = model
        self.reloadSelectTabelView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initSelectTableView()
    }
    
    func reloadSelectTabelView( _ optionModel:ZJJOption? = nil) {
        var model = self.model
        if let md = optionModel {
            model = md
            self.model = md
        }
        selectIndex = -1
        guard let selectValue = model.selectModel?.jj_optionValue,selectValue.count > 0 else {
            self.reloadData()
            return
        }
        self.reloadData()
        for i in 0 ..< model.optionArray.count {
            let item =  model.optionArray[i]
            if selectValue == item.jj_optionValue {
                selectIndex = i
                self.selectModel = item
                let indexPath = IndexPath.init(row: i, section: 0)
                //需要做延时，才能滑动到准确的位置
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.scrollToRow(at: indexPath, at: .middle, animated: false)
                }
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSelectTableView()
    }
    
    private func initSelectTableView() {
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .white
        self.estimatedRowHeight = 100
        self.estimatedSectionHeaderHeight = 0.01
        self.estimatedSectionFooterHeight = 0.01
        self.separatorColor = .clear
        self.separatorLeftRightMargin = 15
    }
    

    func setupBlock(heightForRowBlock:ZJJDefaultSelectTableViewHeightForRowBlock?,cellForRowBlock:ZJJDefaultSelectTableViewCellForRowBlock?) {
        self.heightForRowBlock = heightForRowBlock
        self.cellForRowBlock = cellForRowBlock
    }
}



extension ZJJDefaultSelectTableView:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.model.optionArray[indexPath.row]
        
        if let cellForRowBlock = self.cellForRowBlock {
            if let cell = cellForRowBlock(self,indexPath,model,selectModel) {
                return cell
            }
        }
        
        let cellId = "ZJJDefaultSelectTableViewCellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ZJJDefaultSelectTableViewCell
        
        if cell == nil {
            cell = ZJJDefaultSelectTableViewCell.init(style: .default, reuseIdentifier: cellId)
            cell?.separatorLeftRightMargin = self.separatorLeftRightMargin
        }
        cell?.textLabel?.text = model.jj_optionValue
        cell?.textLabel?.numberOfLines = 0
        cell?.selectionStyle = .none
        if selectIndex == indexPath.row {
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.model.optionArray[indexPath.row]
        if let heightForRowBlock = self.heightForRowBlock {
            
            if let height = heightForRowBlock(self,indexPath,model) {
                return height
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.model.optionArray[indexPath.row]
        self.selectIndex = indexPath.row
        self.selectModel = model
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}


fileprivate class ZJJDefaultSelectTableViewCell: UITableViewCell {
    
    private let lineView = UIView.init()
    var separatorLeftRightMargin:CGFloat = 15{
        didSet{
            self.setupLineViewFrame()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUI()
    }
    func initUI() {
        self.addSubview(self.lineView)
        self.lineView.backgroundColor =  UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLineViewFrame()
    }
    
    func setupLineViewFrame() {
        self.lineView.frame = CGRect.init(x: separatorLeftRightMargin, y: self.frame.size.height-0.5, width: self.frame.size.width-separatorLeftRightMargin*2, height: 0.5)
    }
}
