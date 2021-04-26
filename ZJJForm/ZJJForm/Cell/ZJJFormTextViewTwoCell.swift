//
//  ZJJFormTextViewCell.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/23.
//

import UIKit

class ZJJFormTextViewTwoCell: ZJJFormTextViewBaseCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFormTextViewCellSubView(keyLabel: self.keyLabel, textView: textView, errorLabel: errorLabel)
    }
    
    override func updateFormInputCell(model: ZJJFormInputModel) {
        model.formUI.inputTextAlignment = .left
        super.updateFormInputCell(model: model)
        self.leftMarginConstraint.constant = model.formUI.lineLeftMargin
        self.rightMarginConstraint.constant = model.formUI.lineRightMargin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
