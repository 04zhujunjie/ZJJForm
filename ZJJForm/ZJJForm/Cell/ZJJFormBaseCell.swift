//
//  ZJJFormBaseCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/21.
//

import UIKit

class ZJJFormBaseCell: UITableViewCell,ZJJFormCellBaseProtocol,ZJJFormBlockBaseProtocol {
    
    
    private var formKeyLabel: UILabel?
    private var formValueLabel: UILabel?
    var formLineView: UIView = UIView()
    lazy var formArrowImageView:UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "form_gd__icon"))
        imageView.frame = CGRect.init(x: 0, y: 0, width:7, height: 12)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    open var formModel: ZJJFormBaseModel?
    internal  var formSelectCellBlock:ZJJFormBaseBlock?
    open weak var delegate:ZJJFormEditCellDelegate?
    override var frame: CGRect{
        didSet{
            if let space = self.formModel?.formUI.cellSpace, space > 0 {
                var newFrame = frame
                newFrame.origin.x += space
                newFrame.size.width -= 2 * space
                super.frame = newFrame
            }
        }
    }
    open func formSelectCell(block:@escaping ZJJFormBaseBlock)  {
        self.formSelectCellBlock = block
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initFormBaseCellData()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initFormBaseCellData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initFormBaseCellData() {
        self.addSubview(self.formLineView)
        self.formLineView.isHidden = true
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(setFormSelectCell))
        self.addGestureRecognizer(tap)
    }
    
    
    
    open func setFormBaseCellSubView(keyLabel:UILabel?,valueLabel:UILabel? = nil) {
        self.formKeyLabel = keyLabel
        self.formValueLabel = valueLabel
        keyLabel?.lineBreakMode = .byCharWrapping
        keyLabel?.isUserInteractionEnabled = false
        keyLabel?.isUserInteractionEnabled = false
    }
    
    
    
    open  func updateFormCell(model:ZJJFormBaseModel){
        self.formModel = model
        formLineView.isHidden = model.formUI.isHiddenLine
        formLineView.backgroundColor = model.formUI.separatorLineColor
        self.setFormKeyLabel(model: model)
        self.setFormValueLabel(model: model)
        self.setLineView()
    }
    
    func setFormKeyLabel(model:ZJJFormBaseModel) {
        guard let keyLabel = self.formKeyLabel else {
            return
        }
        keyLabel.lineBreakMode = model.formUI.lineBreakMode
        keyLabel.font = model.formUI.keyTextFont
        keyLabel.textColor = model.formUI.keyTextColor
        let requiredType = model.formText.requiredType
        let keyString = model.formText.key
        if requiredType == .requiredAndStar {
            if keyString.count > 0 {
                let attText = NSMutableAttributedString.init(string: "*\(keyString)")
                attText.setAttributes([NSAttributedString.Key.foregroundColor:model.formUI.starColor], range: NSRange.init(location:0, length: 1))
                keyLabel.attributedText = attText
            }else{
                keyLabel.text = keyString
            }
        }else{
            keyLabel.text = keyString
        }
    }
    
    func setFormValueLabel(model:ZJJFormBaseModel)  {
        guard let valueLabel = self.formValueLabel else {
            return
        }
        valueLabel.lineBreakMode = model.formUI.lineBreakMode
        valueLabel.font = model.formUI.valueTextFont
        valueLabel.textColor = model.formUI.valueTextColor
        valueLabel.text = model.formText.value
        
    }
    
    private func setLineView(){
        if let model = self.formModel {
            
            let selfSize = self.frame.size
            formLineView.frame = CGRect.init(x:model.formUI.lineLeftMargin, y: selfSize.height-model.formUI.lineHeight, width: selfSize.width-model.formUI.lineLeftMargin-model.formUI.lineRightMargin, height: model.formUI.lineHeight)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLineView()
    }
    
    
    
}

extension ZJJFormBaseCell {
    @objc func setFormSelectCell() {
        guard let model = self.formModel else {
            return
        }
        if let delegate = self.delegate{
            delegate.formSelectCell?(model:model , cell: self)
        }
        if let changeBlock = self.formSelectCellBlock {
            changeBlock(model,self)
        }
        if let changeBlock = model.formSelectCellBlock {
            changeBlock(model,self)
        }
    }
}
