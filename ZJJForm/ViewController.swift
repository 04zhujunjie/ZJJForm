//
//  ViewController.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/16.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView:ZJJFormTableView = {
        let tableView = ZJJFormTableView.init(frame: self.view.bounds, style: .plain)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
//        tableView.dataArray = [self.getName(),self.getPhone(),self.getCard(),self.getEmail(),self.getAddress(),self.getCard(),self.getEmail(),self.getPhone(),self.getCard(),self.getEmail()]
        tableView.dataArray = [self.getName(),self.getCard()]
        tableView.dataArray.append(self.getEmail())
        tableView.isTouchEndEditing = true
        let rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let formModel =  ZJJFormModel.init(cellStyle: .customIdentifier("ZJJJJJ"), model: ZJJFormInputModel())
        
        
        print("++++-----\(formModel.cellStyle.cellIdentifier())")

    }

    @objc func save(){
        self.view.endEditing(true)
        let param = ZJJFormParam.init(dataArray: tableView.dataArray)
        if param.isValid {

            print("====\(param.param)===")
        }else{
            self.tableView.reloadData()
        }
    
    }
    
    
    func getName() -> ZJJFormModel {
       let inputModel = ZJJFormInputModel()
       
       let formModel =  ZJJFormModel.init(cellStyle: .input1, model: inputModel)

        inputModel.verify = ZJJFormVerify.init(type: .editing,errorMsg: "只能输入英文字母", verifyValueBlock: { (value) -> (ZJJFormInputErrorType) in
            if value.verifyRegex(of: kZJJOnlySpaceAndEnglishRegex){
                return .none
            }
            return .lineAndLabel
        })
    
        inputModel.formUI.isShowArrow = true
        inputModel.verify.isBeginEnditingHiddenError = true
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "姓名", value: "xioa", serviceKey: "name")
        inputModel.placeholder = "请输入"
        inputModel.maxLength = 60
        inputModel.formText = textModel
        return formModel
        
    }
    
   
    
    func getPhone() -> ZJJFormModel {
        let baseModel = ZJJFormBaseModel()
        let formModel = ZJJFormModel.init(cellStyle: .value2, model: baseModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "电话", value: "1092099200902", serviceKey: "phone")
        baseModel.formText = textModel
        return formModel
        
    }
    
    func getCard() -> ZJJFormModel {
        let inputModel = ZJJFormInputModel()
        let formModel = ZJJFormModel.init(cellStyle: .textView2, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "银行卡号", value: "19820992892892892".formateForBankCard(), serviceKey: "cardNo")
        
//        inputModel.formUI.isShowArrow = true
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
        let formModel = ZJJFormModel.init(cellStyle: .input2, model: inputModel)
        let textModel = ZJJFormText.init(requiredType: .requiredAndStar, key: "邮箱", value: "1202@qq.com", serviceKey: "email")
//        let textModel = ZJJFormText.init(valueType: 0, requiredType: .requiredAndStar, key: "邮箱", value: "1202@qq.com", serviceKey: "email")
        var uiModel = ZJJFormUI()
        uiModel.lineLeftMargin = 20
        uiModel.lineRightMargin = 20
        inputModel.formUI = uiModel
        inputModel.formText = textModel
        inputModel.placeholder = "请输入邮箱地址"
        inputModel.keyboardType = .emailAddress
        inputModel.maxLength = 32
//        inputModel.verify = ZJJFormVerify.init(type: .editing, errorMsg: "在长度", verifyValueBlock: { (value) -> (ZJJFormInputErrorType) in
//            if !value.verfiyLength(min: 4, max: 10){
//                return .lineAndLabel
//            }
//            return .none
//        })
        inputModel.formSelectCell { (model, cell) in
            print("======\(model.formText.key)")
        }
        inputModel.formValueBeginEditing { (model, cell) in
            print("----\(model.formText.key)-----")
        }
        return formModel
        
    }
    
    func getAddress() -> ZJJFormModel {
        let formModel = ZJJFormModel.init(cellStyle: .value1, model: ZJJFormBaseModel.init())
        formModel.cellStyle = .value1
        let textModel = ZJJFormText.init(requiredType: .none, key: "配送地址", value: "guangdongsheng guangzhoushi tianhequ zhujiangxincheng 007号", serviceKey: "address")
        var uiModel = ZJJFormUI.init()
        uiModel.isShowArrow = true
        formModel.model.formText = textModel
        formModel.model.formUI = uiModel
        formModel.model.formSelectCell { (model, cell) in
            print("======\(model.formText.key)")
        }
        return formModel
    }

}

