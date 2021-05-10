//
//  ZJJFormTextViewOneCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/25.
//

import UIKit

class ZJJFormTextViewOneCell: ZJJFormTextViewBaseCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var valueRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineLeftConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFormTextViewCellSubView(keyLabel: keyLabel, textView: textView, errorLabel: errorLabel)
        // Initialization code
    }
    
    override func updateFormInputCell(model: ZJJFormInputModel) {
        if model.isKind(of: ZJJFormOptionModel.self) {
            textView.isEditable = false
            textView.isUserInteractionEnabled = false
            if model.formText.value.count > 0 {
                model.verify.errorType = .none
            }
        }else{
            textView.isEditable = true
            textView.isUserInteractionEnabled = true
        }
        super.updateFormInputCell(model: model)
        self.updateCell(model: model)
    }

    func updateCell(model:ZJJFormBaseModel)  {

        self.lineLeftConstraint.constant = model.formUI.lineLeftMargin
        self.lineRightConstraint.constant = model.formUI.lineRightMargin
        if model.formUI.isShowArrow {
            self.arrowImageView.isHidden = false
            self.valueRightConstraint.constant = 10.0
        }else{
            self.arrowImageView.isHidden = true
            self.valueRightConstraint.constant = 0
        }
       
        self.setNeedsLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
