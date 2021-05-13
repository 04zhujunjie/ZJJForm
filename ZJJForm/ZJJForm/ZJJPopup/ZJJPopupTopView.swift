//
//  ZJJPopupTopView.swift
//  ZJJPopup
//
//  Created by weiqu on 2021/4/27.
//

import UIKit

typealias ZJJPopupTopViewButtonBlock = (UIButton) -> ()

class ZJJPopupTopView: UIView {
    
    private let titleLabel = UILabel()
    private let lineView:UIView = UIView()
    public let cancelButton = UIButton()
    public let confirmButton = UIButton()
    private var cancelButtonBlock:ZJJPopupTopViewButtonBlock?
    private var confirmButtonBlock:ZJJPopupTopViewButtonBlock?
    private var config:ZJJPopupTopViewConfig =  ZJJPopupTopViewConfig()
    
     
    
    init(frame: CGRect = .zero,config:ZJJPopupTopViewConfig = ZJJPopupTopViewConfig()) {
        super.init(frame: frame)
        self.setup(frame: frame, config: config)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(frame:CGRect,config:ZJJPopupTopViewConfig) {
        var selfFrame = frame
        if frame.size.width < 1 {
            selfFrame.size.width = UIScreen.main.bounds.width
        }
        self.frame = selfFrame
        confirmButton.contentEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        self.config = config
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClick(btn:)), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmButtonClick(btn:)), for: .touchUpInside)
        self.setupUI()
    }
    
    func clickCancelButton(block:ZJJPopupTopViewButtonBlock?) {
        self.cancelButtonBlock = block
    }
    
    func clickConfirmButton(block:ZJJPopupTopViewButtonBlock?) {
        self.confirmButtonBlock = block
    }
    
    private func setupUI() {
        
        var cancelSize = CGSize.zero
        var confirmSize = CGSize.zero
        var titleWidth:CGFloat = 0
        var titleHeight:CGFloat = 0
        self.backgroundColor = config.backgroundColor
        if !config.cancelConfig.isHidden {
            self.addSubview(self.cancelButton)
            cancelButton.contentEdgeInsets = .init(top: 0, left: config.cancelConfig.leftRightMargin, bottom: 0, right: config.cancelConfig.leftRightMargin)
            self.setup(view: cancelButton, config: config.cancelConfig)
            cancelSize = self.getBtnSize(config: config.cancelConfig)
            if config.cancelConfig.cornerRadius == ZJJPopupButtonConfig.halfRadius {
                cancelButton.layer.cornerRadius = cancelSize.height/2.0
            }
        }
        
        if !config.confirmConfig.isHidden {
            self.addSubview(self.confirmButton)
            confirmButton.contentEdgeInsets = .init(top: 0, left: config.confirmConfig.leftRightMargin, bottom: 0, right: config.confirmConfig.leftRightMargin)
            self.setup(view: confirmButton, config: config.confirmConfig)
            confirmSize = self.getBtnSize(config: config.confirmConfig)
            if config.confirmConfig.cornerRadius == ZJJPopupButtonConfig.halfRadius {
                confirmButton.layer.cornerRadius = confirmSize.height/2.0
            }
        }
        
        if !config.titleConfig.isHidden {
            
            self.addSubview(self.titleLabel)
            self.setup(view: titleLabel, config: config.titleConfig)
            titleWidth = self.getTitleWidth(cancelSize: cancelSize, confirmSize: confirmSize)
            
            if titleWidth > 0 {
                let height = self.getHeight(width: titleWidth, config: config.titleConfig)
                if config.titleConfig.numberOfLines == 0 {
                    titleHeight = height
                }else if config.titleConfig.numberOfLines > 1{
                    let heightN = CGFloat(22*config.titleConfig.numberOfLines)+10
                    if height > heightN {
                        titleHeight = heightN
                    }else{
                        titleHeight = height
                    }
                    
                }else{
                    titleHeight = 30
                }
                
            }
        }
        
        
        //取最大值作为topView的高度
        let viewHeight = max(cancelSize.height+config.cancelConfig.minTopBottom*2, confirmSize.height+config.confirmConfig.minTopBottom*2, titleHeight, config.minHeight)
        
        var selfFrame = self.frame
        selfFrame.size.height = viewHeight
        self.frame = selfFrame
        
        self.cancelButton.frame = CGRect.init(origin: CGPoint.init(x: config.cancelConfig.margin, y: 0), size: cancelSize)
        self.cancelButton.center = CGPoint.init(x:self.cancelButton.center.x , y: viewHeight/2.0)
        self.confirmButton.frame  = CGRect.init(origin: CGPoint.init(x: self.frame.size.width - config.confirmConfig.margin-confirmSize.width, y: 0), size: confirmSize)
        self.confirmButton.center = CGPoint.init(x:self.confirmButton.center.x , y: viewHeight/2.0)
        
        self.setupTitleFrame(width: titleWidth, height: titleHeight, viewHeight: viewHeight)
        
        if !config.separatorConfig.isHidden {
            self.addSubview(self.lineView)
            self.lineView.backgroundColor = config.separatorConfig.color
            self.lineView.frame = CGRect.init(x: 0, y: viewHeight-config.separatorConfig.height, width: self.frame.size.width, height:config.separatorConfig.height)
        }
        
        
    }
    
    private func getTitleWidth(cancelSize:CGSize,confirmSize:CGSize) -> CGFloat{
        let titleWidth:CGFloat = self.frame.size.width - config.titleConfig.leftRightMargin*2 - config.cancelConfig.margin-config.confirmConfig.margin
        if !config.isTitleAutomaticCenter {
            
            if config.cancelConfig.isHidden && !config.confirmConfig.isHidden {
                //取消按钮是隐藏，但确定按钮不隐藏
                return titleWidth - confirmSize.width
            }
            if config.confirmConfig.isHidden && !config.cancelConfig.isHidden {
                //取消按钮显示，确定按钮隐藏
                return titleWidth - cancelSize.width
            }
        }
        
        return titleWidth -  max(cancelSize.width, confirmSize.width)*2
    }
    
    private func setupTitleFrame(width:CGFloat,height:CGFloat,viewHeight:CGFloat){
        if !config.isTitleAutomaticCenter {
            
            if config.cancelConfig.isHidden && !config.confirmConfig.isHidden {
                //取消按钮是隐藏，但确定按钮显示
                self.titleLabel.frame = CGRect.init(x: config.cancelConfig.margin + config.titleConfig.leftRightMargin, y: 0, width: width, height: viewHeight)
                self.titleLabel.center = CGPoint.init(x: self.titleLabel.center.x, y: viewHeight/2.0)
                return
            }
            if config.confirmConfig.isHidden && !config.cancelConfig.isHidden {
                //取消按钮显示，确定按钮隐藏
                self.titleLabel.frame = CGRect.init(x: config.cancelConfig.margin + config.titleConfig.leftRightMargin + self.cancelButton.frame.size.width, y: 0, width: width, height: height)
                self.titleLabel.center = CGPoint.init(x: self.titleLabel.center.x, y: viewHeight/2.0)
                return
            }
        }
        self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        self.titleLabel.center = CGPoint.init(x: self.frame.size.width/2.0, y: viewHeight/2.0)
        
    }
    
    private  func getBtnSize(config:ZJJPopupButtonConfig) -> CGSize {
        if !config.isHidden {
            let maxWidth:CGFloat = config.maxWidth
            //文本内容距离按钮的左右边距
            let buttonEdgeInsetLeftRight = config.leftRightMargin
            let width = config.text.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 25), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:config.font], context: nil).size.width
            let btnHeight = self.config.minHeight - config.minTopBottom*2
            
            if width > maxWidth {
                //文本的宽度大于最大宽度
                //按钮的宽度
                let btnWidth = maxWidth+buttonEdgeInsetLeftRight*2
                if config.numberOfLines == 0 {
                    return CGSize.init(width: btnWidth, height: self.getHeight(width: maxWidth, config: config))
                }else if config.numberOfLines > 1{
                    return CGSize.init(width: btnWidth, height: btnHeight*CGFloat(config.numberOfLines)*5/6)
                }
                return CGSize.init(width: btnWidth, height: btnHeight)
            }else{
                return CGSize.init(width: width+buttonEdgeInsetLeftRight*2, height: btnHeight)
            }
            
        }
        return CGSize.zero
    }
    //计算文本的高度
    private  func getHeight(width:CGFloat,config:ZJJPopupUIConfig) -> CGFloat {
        if !config.isHidden {
            let height = config.text.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:config.font], context: nil).size.height
            return height + 20
        }
        return 0
    }
    
    private func setup(view:UIView,config:ZJJPopupUIConfig) {
        
        if let btn = view as? UIButton {
            btn.titleLabel?.font = config.font
            btn.titleLabel?.numberOfLines = config.numberOfLines
            btn.setTitle(config.text, for: .normal)
            btn.setTitle(config.text, for: .highlighted)
            btn.setTitleColor(config.color, for: .normal)
            btn.setTitleColor(config.color, for: .highlighted)
        } else if let label = view as? UILabel {
            
            label.font = config.font
            label.text = config.text
            label.textColor = config.color
            label.numberOfLines = config.numberOfLines
            label.textAlignment = config.textAlignment
        }
        view.backgroundColor = config.backgroundColor
        
        if config.masksToBounds {
            view.layer.masksToBounds = config.masksToBounds
            view.layer.borderWidth = config.borderWidth
            view.layer.borderColor = config.borderColor.cgColor
            view.layer.cornerRadius = config.cornerRadius
        }
    }
    
    @objc private func cancelButtonClick(btn:UIButton){
        if let block = self.cancelButtonBlock {
            block(btn)
        }
    }
    
    @objc private func confirmButtonClick(btn:UIButton){
        if let block = self.confirmButtonBlock {
            block(btn)
        }
    }
    
}
