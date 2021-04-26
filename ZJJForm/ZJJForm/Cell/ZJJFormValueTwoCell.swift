//
//  ZJJFormValueTwoCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/19.
//

import UIKit

class ZJJFormValueTwoCell: ZJJFormBaseCell {

    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var lineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineLeftConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.isHidden = true
        self.setFormBaseCellSubView(keyLabel: keyLabel, valueLabel: valueLabel)
    }
//
   override func updateFormCell(model:ZJJFormBaseModel){
        super.updateFormCell(model: model)
        self.updateCell(model: model)
    }

    func updateCell(model:ZJJFormBaseModel)  {
        self.lineLeftConstraint.constant = model.formUI.lineLeftMargin
        self.lineRightConstraint.constant = model.formUI.lineRightMargin
        self.setNeedsLayout()
    }
    
}
