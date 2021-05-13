//
//  CustomController.swift
//  ZJJForm
//
//  Created by weiqu on 2021/5/12.
//

import UIKit

enum ZJJFormCustomValueType:Int {
    case compayAddress = 10
    
}

fileprivate let kScreenWidth = UIScreen.main.bounds.width

fileprivate let kCellSpace:CGFloat = 12

fileprivate let kCompayAddressCellId = "CompayAddressCellID"

class CustomController: UIViewController {
    lazy var tableView:ZJJFormTableView = {
        let tableView = ZJJFormTableView.init(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isTouchEndEditing = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        //注册自定义的Cell
        self.tableView.register(UINib.init(nibName: "CompayAddressCell", bundle: nil), forCellReuseIdentifier: kCompayAddressCellId)
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20))
        let personInfo = ZJJFormSectionModel.init(title: "个人信息", list:[self.getName(),self.getGender(),self.getPhone()])
        let compayInfo = ZJJFormSectionModel.init(title: "公司信息", list:[self.getCompanyName(),self.getCompanyEmail(),self.getCompayAddress()])
        self.tableView.dataArray = [personInfo,compayInfo]
        self.tableView.reloadData()
        
        let rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
    }
    
    @objc func save(){
        self.view.endEditing(true)
        var param = ZJJFormParam.init(dataArray: tableView.dataArray,filterValueTypes: [ZJJFormCustomValueType.compayAddress.rawValue])
        if param.isValid {
            
            for item in param.filterArray {

                if item.model.valueType == ZJJFormCustomValueType.compayAddress.rawValue {
                    //公司地址
                    if let optionModel = item.model as? CompayAddressInputModel {
                        
                        if let selectModel = optionModel.option.selectModel as? AreaModel {
                            param.param["compayAddressCityID"] = selectModel.id
                        }else{
                            print("===请选择城市====")
                        }
                        param.param[item.model.formText.serviceKey] = optionModel.formText.value
                    }
                    
                }
            }
            
        print("====\(param.param)===")
            
        }else{
            print("==第一个错误的提示===\(param.firstErrorMsg ?? "")")
            self.tableView.reloadData()
        }
       
    }
    
    func getName() -> ZJJFormModel {
       let inputModel = ZJJFormInputModel()
       let formModel =  ZJJFormModel.init(cellStyle: .input1, model: inputModel)
        inputModel.verify = ZJJFormVerify.init(type: .editing,errorMsg: "只能输入英文字母", verifyValueBlock: { (value) -> (ZJJFormInputErrorType) in
            if value.verifyRegex(of: "^[a-zA-Z / s{0,1}]+$"){
                return .none
            }
            return .lineAndLabel
        })
    
        inputModel.verify.isBeginEnditingHiddenError = true
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "姓名", value: "", serviceKey: "name")
        inputModel.placeholder = "请输入"
        inputModel.maxLength = 60
        inputModel.formText = textModel
        inputModel.formUI = self.getFormUI()
        inputModel.returnDoneType = .hiddenKeyboard
        return formModel
        
    }
    
    func getGender() -> ZJJFormModel {
        let optionModel = ZJJFormOptionModel.init()
        optionModel.option.optionArray = [ZJJGenderModel.init(id: 0),ZJJGenderModel.init(id: 1),ZJJGenderModel.init(id: 2)]
        optionModel.formUI.isShowArrow = true
        
        var value = ""
        if let selectModel = optionModel.option.selectModel {
            value = selectModel.jj_optionValue ?? ""
        }
        
        optionModel.formText = ZJJFormText.init(requiredType: .requiredAndStar, key: "性别", value: value, serviceKey: "gender")
        optionModel.valueType = ZJJFormValueType.gender.rawValue
        optionModel.formSelectCell { (model, cell) in
            self.showPopupView(optionModel: optionModel)
        }
        optionModel.formUI = self.getFormUI()
        optionModel.placeholder = "请选择性别"
        optionModel.verify = ZJJFormVerify.init(errorMsg: "请选择性别")
        let formModel = ZJJFormModel.init(cellStyle: .option, model: optionModel)
        
        return formModel
    }
    
    func getPhone() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        inputModel.formUI = self.getFormUI()
        let formModel = ZJJFormModel.init(cellStyle: .input1, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "手机号", value: "", serviceKey: "phone")
        inputModel.formText = textModel
        inputModel.placeholder = "请输入手机号"
        inputModel.keyboardType = .numberPad
        inputModel.maxLength = 13 //显示文本的长度
        inputModel.formText = textModel
        
        let topViewConfig = ZJJPopupTopViewConfig.init()
        topViewConfig.cancelConfig.isHidden = true
        topViewConfig.titleConfig.text = "正在输入手机号"
        topViewConfig.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        topViewConfig.confirmConfig.set(cornerRadius:5)//设置圆角
        topViewConfig.confirmConfig.color = .white
        topViewConfig.confirmConfig.backgroundColor = UIColor(red: 0.27, green: 0.51, blue: 0.98, alpha: 1)
        let topView = ZJJPopupTopView.init(config: topViewConfig)
        topView.jj_setCornersRadius(radius: 10, roundingCorners: [.topLeft,.topRight])
        topView.clickConfirmButton { (btn) in
            self.view.endEditing(true)
        }
        inputModel.inputAccessoryView = topView
        return formModel
        
    }
    
    func getCompanyName() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        let formModel =  ZJJFormModel.init(cellStyle: .textView1, model: inputModel)
         let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "公司名称", value: "", serviceKey: "companyName")
         inputModel.placeholder = "请输入"
         inputModel.maxLength = 60
         inputModel.formText = textModel
         inputModel.formUI = self.getFormUI()
        inputModel.returnDoneType = .next
         return formModel
    }
    
    func getCompanyEmail() -> ZJJFormModel {
        
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .textView1, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .none, key: "公司邮箱", value: "", serviceKey: "companyEmail")
        inputModel.formUI = self.getFormUI()
        inputModel.formText = textModel
        inputModel.placeholder = "请输入公司邮箱地址"
        inputModel.keyboardType = .emailAddress
        inputModel.maxLength = 50
        inputModel.returnDoneType = .hiddenKeyboard
        inputModel.formSelectCell { (model, cell) in
//            print("======\(model.formText.key)")
        }
        inputModel.formValueBeginEditing { (model, cell) in
//            print("----\(model.formText.key)-----")
        }
        inputModel.verify = ZJJFormVerify.init(type: .endEdit, errorMsg: "邮箱格式不对", verifyValueBlock: { [weak inputModel](value) -> (ZJJFormInputErrorType) in
            
            if value.count == 0{
                return .none
            }
            if value.count < 4 {
                inputModel?.verify.errorMsg = "邮箱长度必须大于4位数"
                return .lineAndLabel
            }
            if !value.verifyEmail() {
                inputModel?.verify.errorMsg = "邮箱格式不对"
                return .lineAndLabel
            }
            return .none
        })
        return formModel
    }
    
    func getCompayAddress() -> ZJJFormModel {
        let inputModel = CompayAddressInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .customIdentifier(kCompayAddressCellId), model: inputModel)
        formModel.model.valueType = ZJJFormCustomValueType.compayAddress.rawValue
        let textModel = ZJJFormText.init(requiredType: .none, key: "公司详细地址", value: "", serviceKey: "companyAddress")
        inputModel.formUI = self.getFormUI()
        inputModel.formText = textModel
        inputModel.placeholder = "请输入公司详细地址"
        inputModel.keyboardType = .emailAddress
        inputModel.maxLength = 50
        inputModel.option.optionArray = [AreaModel.init(optionValue: "广州", id: 123),AreaModel.init(optionValue: "深圳", id: 456),AreaModel.init(optionValue: "上海", id: 789),AreaModel.init(optionValue: "北京", id: 100)]
        inputModel.returnDoneType = .hiddenKeyboard
        return formModel
    }
    
    func getFormUI() -> ZJJFormUI {
        var formUI = ZJJFormUI()
        formUI.cellSpace = kCellSpace
        formUI.isShowArrow = true
        return formUI
    }

    func showPopupView(optionModel:ZJJFormOptionModel) {
        
        ZJJPopup.pickerView(optionModel: optionModel.option, title: "请选择性别") { (pickerView, popupView, model, btn) in
            if let genderModel = model as? ZJJGenderModel {
                optionModel.option.selectModel = genderModel
                optionModel.formText.value = genderModel.jj_optionValue ?? ""
                self.tableView.reloadData()
            }
        }
    }
    
    func showPopupView(textField:UITextField,compayAddressModel: CompayAddressInputModel) {
        
        self.view.endEditing(true)
        
        var popupModel = ZJJPopupModel()
        popupModel.isTouchHidden = false
        popupModel.blurEffectStyle = .light
        popupModel.topViewConfig.titleConfig.text = "请选择城市"
        popupModel.topViewConfig.titleConfig.color = .orange
        popupModel.topViewConfig.cancelConfig.text = "cancel"
        popupModel.topViewConfig.confirmConfig.text = "confirm"
        
        popupModel.topViewConfig.cancelConfig.color = .blue
        popupModel.topViewConfig.confirmConfig.color = .orange
        
        ZJJPopup.tableView(optionModel: compayAddressModel.option, popupModel: popupModel) { (pickerView, popupView, model, btn) in
            if let areaModel = model as? AreaModel {
                let value = areaModel.jj_optionValue ?? ""
                compayAddressModel.option.selectModel = areaModel
                compayAddressModel.formText.value = value
                textField.text = value
            }
        }
    }
}




extension CustomController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableView.dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataArray[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.tableView.dataArray[indexPath.section].list[indexPath.row]
        let identifier = model.cellStyle.cellIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let compayAddressCell = cell as? CompayAddressCell {
            compayAddressCell.selectCity { (textField, model) in
                self.showPopupView(textField: textField, compayAddressModel: model)
            }
        }
        cell.backgroundColor = .white
        self.tableView.setFormEditCellDelegate(model: model.model, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.tableView.dataArray[indexPath.section].list[indexPath.row]
        return model.model.formUI.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: kCellSpace, y: 0, width: kScreenWidth - kCellSpace*2, height: 40))
        view.backgroundColor = .clear
        
        let radiusView = UIView.init(frame: CGRect.init(x: kCellSpace, y: 0, width: kScreenWidth - kCellSpace*2, height: view.frame.size.height))
        radiusView.backgroundColor = .white
        radiusView.jj_setCornersRadius(radius: 10, roundingCorners: [.topLeft,.topRight])
        view.addSubview(radiusView)
        
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: radiusView.frame.size.width-30, height: 20))
        let model = self.tableView.dataArray[section]
        label.text = model.title
        label.textColor = .blue
        radiusView.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 30))
        view.backgroundColor = .clear
        let radiusView = UIView.init(frame: CGRect.init(x: kCellSpace, y: 0, width: kScreenWidth - kCellSpace*2, height: 20))
        radiusView.backgroundColor = .white
        radiusView.jj_setCornersRadius(radius: 10, roundingCorners: [.bottomLeft,.bottomRight])
        view.addSubview(radiusView)
        return view
    }
    

}
