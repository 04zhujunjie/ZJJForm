//
//  ViewController.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//

import UIKit

enum ZJJFormValueType:Int {
    case gender = 1
    case card = 2
    
}

class ViewController: UIViewController {

    lazy var tableView:ZJJFormTableView = {
        let tableView = ZJJFormTableView.init(frame: self.view.bounds, style: .plain)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataArray = [ZJJFormSectionModel.init(title: "", list: [self.getName(),self.getGender(),self.getPhone(),self.getCard(),self.getEmail(),self.getAddress(),self.getPersonalSignature()])]
        tableView.isTouchEndEditing = true
        let rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let formModel =  ZJJFormModel.init(cellStyle: .customIdentifier("ZJJJJJ"), model: ZJJFormInputModel())
        
        
        print("++++-----\(formModel.cellStyle.cellIdentifier())")

    }

    @objc func save(){
        self.view.endEditing(true)
        var param = ZJJFormParam.init(dataArray: tableView.dataArray,filterValueTypes: [ZJJFormValueType.gender.rawValue,ZJJFormValueType.card.rawValue])
        if param.isValid {
            
            for item in param.filterArray {

                if item.model.valueType == ZJJFormValueType.gender.rawValue {
                    //性别
                    if let optionModel = item.model as? ZJJFormOptionModel,let selectModel = optionModel.option.selectModel as? ZJJGenderModel {
                        param.param[item.model.formText.serviceKey] = selectModel.genderId
                    }
                    
                }else if item.model.valueType == ZJJFormValueType.card.rawValue{
                    //银行卡,去掉间隔空格
                    let cardNo = item.model.formText.value.replacingOccurrences(of: " ", with: "")
                    param.param[item.model.formText.serviceKey] = cardNo
                }
            }
            
        print("====\(param.param)===")
            
        }else{
            print("==第一个错误的提示===\(param.firstErrorMsg ?? "")")
            self.tableView.reloadData()
        }
       
    }
    
    func getData() -> ZJJOption {
        var option = ZJJOption()
        for i in 0 ..< 10 {
            let testModel = ZJJTestModel()
            testModel.id = CGFloat(i+1)
            testModel.jj_optionValue = "选项\(i+1)"
            option.optionArray.append(testModel)
        }
        option.selectModel = option.optionArray.last
        return option
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
        return formModel
        
    }
    
    func getGender() -> ZJJFormModel {
        let optionModel = ZJJFormOptionModel.init()
        optionModel.option.optionArray = [ZJJGenderModel.init(id: 0),ZJJGenderModel.init(id: 1),ZJJGenderModel.init(id: 2)]
//        optionModel.option.selectModel = optionModel.option.optionArray.first
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
        optionModel.placeholder = "请选择性别"
        optionModel.verify = ZJJFormVerify.init(errorMsg: "请选择性别")
        let formModel = ZJJFormModel.init(cellStyle: .option, model: optionModel)

        return formModel
    }
    
    func getPhone() -> ZJJFormModel {
        let baseModel = ZJJFormBaseModel()
        let formModel = ZJJFormModel.init(cellStyle: .value1, model: baseModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "电话", value: "18866668888", serviceKey: "phone")
        baseModel.formText = textModel
        baseModel.formSelectCell { (model, cell) in
          
        }
        return formModel
        
    }
    
    func getCard() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .textView2, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "银行卡号", value: "1982099289289289".formateForBankCard(), serviceKey: "cardNo")
        inputModel.valueType = ZJJFormValueType.card.rawValue
        inputModel.placeholder = "请输入银行卡号"
        inputModel.keyboardType = .numberPad
        inputModel.formText = textModel
        inputModel.formValueChange { (model, cell) in
            if let inputCell = cell as? ZJJFormTextViewTwoCell {
                inputCell.textView.text = model.formText.value.formateForBankCard()
            }
        }
        return formModel
        
    }
    
    func getEmail() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .input1, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "邮箱", value: "1202@qq.com", serviceKey: "email")
        var uiModel = ZJJFormUI()
        uiModel.isShowArrow = true
        uiModel.lineLeftMargin = 30
        uiModel.lineRightMargin = 30
        inputModel.formUI = uiModel
        inputModel.formText = textModel
        inputModel.placeholder = "请输入邮箱地址"
        inputModel.keyboardType = .emailAddress
        inputModel.maxLength = 30
        inputModel.formSelectCell { (model, cell) in
//            print("======\(model.formText.key)")
        }
        inputModel.formValueBeginEditing { (model, cell) in
//            print("----\(model.formText.key)-----")
        }
        return formModel
        
    }
    
    func getAddress() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .textView2, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .none, key: "居住地址", value: "guangdongsheng guangzhoushi tianhequ zhujiangxincheng 007号", serviceKey: "address")
        var uiModel = ZJJFormUI.init()
        uiModel.isShowArrow = true
        formModel.model.formText = textModel
        formModel.model.formUI = uiModel
        inputModel.placeholder = "请输入居住地址"
        inputModel.maxLength = 100
        formModel.model.formSelectCell { (model, cell) in
            print("======\(model.formText.key)")
        }
        return formModel
    }
    
    func getPersonalSignature() -> ZJJFormModel {
        
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .textView1, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "个人说明", value: "", serviceKey: "personalSignature")
        let maxLenght:Int = 25
        inputModel.formUI.isShowArrow = true
        inputModel.placeholder = "请输入,最多只能输入\(maxLenght)个字符"
        inputModel.formText = textModel
        inputModel.verify = ZJJFormVerify.init(type: .editing, errorMsg: "至少输入一个字符，最多只能输入\(maxLenght)个字符", verifyValueBlock: { (value) -> (ZJJFormInputErrorType) in
            if value.verfiyLength(min: 0, max: maxLenght){
                return .none
            }
            return .lineAndLabel
        })

        return formModel
    }

}

