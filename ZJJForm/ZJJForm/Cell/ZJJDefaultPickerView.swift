//
//  ZJJDefaultPickerView.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/27.
//

import UIKit

struct ZJJPickerUI {
    var normalColor:UIColor = .black //文本正常颜色
    var selectColor:UIColor = .black //文本选择的颜色
    var font:UIFont = UIFont.systemFont(ofSize: 17) //字体大小
    var leftRightMargin:CGFloat = 20 //文本左右边距
    var rowHeight:CGFloat = 40 //行高
    var separatorLineColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.3) //分割线的颜色
}

class ZJJDefaultPickerView: UIPickerView {

    private var selectIndex:Int = 0
    open var selectModel:ZJJOptionProtocol?
    var pickerUI:ZJJPickerUI = ZJJPickerUI(){
        didSet{
            self.reloadComponent(0)
        }
    }
    var model:ZJJOption = ZJJOption()
    
    init (frame:CGRect,model:ZJJOption,pickerUI:ZJJPickerUI = ZJJPickerUI()){
        super.init(frame: frame)
        self.pickerUI = pickerUI
        self.initData()
        self.model = model
        self.reloadPicker(model)
    }

    func reloadPicker( _ optionModel:ZJJOption? = nil) {
        var model = self.model
        if let md = optionModel {
            model = md
            self.model = model
            self.reloadComponent(0)
        }
        selectIndex = 0
        self.selectModel = model.optionArray.first
        guard let selectValue = model.selectModel?.jj_optionValue,selectValue.count > 0 else {
            self.reloadComponent(0)
            return
        }
        for i in 0 ..< model.optionArray.count {
            let item =  model.optionArray[i]
            if selectValue == item.jj_optionValue {
                selectIndex = i
                self.selectModel = item
                self.selectRow(selectIndex, inComponent: 0, animated: false)
                self.reloadComponent(0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initData()
    }
    
   private func initData() {
        self.delegate = self
        self.dataSource = self
        self.showsSelectionIndicator = true
    }

}

extension ZJJDefaultPickerView:UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.optionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let optionArray = self.model.optionArray
        if row < optionArray.count {
            if let text = optionArray[row].jj_optionValue {
                return text
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return self.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let optionArray = self.model.optionArray
        if row < optionArray.count {
            selectIndex = row
            self.selectModel = optionArray[row]
            self.reloadComponent(0)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.pickerUI.rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        for view in pickerView.subviews {
            if view.frame.size.height < 1 {
                //设置分割线颜色
                view.backgroundColor = pickerUI.separatorLineColor
            }
        }
        
        var pickerLabel:UILabel? = nil

        if let label = view as? UILabel {
            pickerLabel = label
        }
        if pickerLabel == nil {
            let label = UILabel.init(frame: .init(x: self.pickerUI.leftRightMargin, y:0, width: self.frame.size.width-self.pickerUI.leftRightMargin*2, height: 50))
            label.textAlignment = .center
            label.numberOfLines = 2
            label.backgroundColor = .clear
            label.font = self.pickerUI.font
            pickerLabel = label
        }
        if self.selectIndex == row {
            pickerLabel?.textColor = self.pickerUI.selectColor
        }else{
            pickerLabel?.textColor = self.pickerUI.normalColor
        }
        pickerLabel?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel!
    }
    

}
