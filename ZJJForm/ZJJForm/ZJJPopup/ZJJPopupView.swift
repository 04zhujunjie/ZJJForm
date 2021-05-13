//
//  ZJJPopupView.swift
//  ZJJPopup
//
//  Created by weiqu on 2021/4/26.
//

import UIKit


typealias ZJJPopupViewBlock = (ZJJPopupView,UIButton) -> ()

public enum ZJJPopupViewShowInType{
    case window //添加到window上
    case vc //添加到当前的UIViewController上
    case nc //添加到UINavigationController上
}

public enum ZJJBlurEffectStyle:Int{
    case none = -1
    case extraLight = 0
    case light = 1
    case dark = 2
}

public enum ZJJPopupAnimationType {
    case move
    case scale
    case fade
}

class ZJJPopupView: UIView,UIGestureRecognizerDelegate {
    
    private let popupView = UIView()
    private var model:ZJJPopupModel = ZJJPopupModel()
    private var topView:ZJJPopupTopView = ZJJPopupTopView()
    private var contentView:UIView = UIView()
    private var confirmBlock:ZJJPopupViewBlock?
    private var cancelBlock:ZJJPopupViewBlock?
    private var animationType:ZJJPopupAnimationType = .move
    private var isAnimation:Bool = false //是否正在进行显示或消失的动画
    private var jj_window:UIWindow?
    private var jj_showInView:UIView?
    private var effectView: UIVisualEffectView?
    convenience init(contentView:UIView,popupModel:ZJJPopupModel = ZJJPopupModel(),confirmBlock: ZJJPopupViewBlock? = nil){
        self.init(contentView:contentView,popupModel:popupModel,confirmBlock: confirmBlock,cancelBlock: nil)
    }
    
    init(contentView:UIView,popupModel:ZJJPopupModel,confirmBlock: ZJJPopupViewBlock? = nil,cancelBlock: ZJJPopupViewBlock? = nil) {
        super.init(frame: .zero)
        self.jj_window = UIWindow.current()
        self.model = popupModel
        self.animationType = popupModel.animationType
        self.showInView()
        self.frame = CGRect.init(x: 0, y: 0, width: self.getViewWidth(), height: self.getViewHeight())
        
        self.contentView = contentView
        if model.isTouchHidden {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidden))
            tap.delegate = self
            self.addGestureRecognizer(tap)
        }
        if !model.topViewConfig.isHidden {
            self.setupTopView()
            self.confirmBlock = confirmBlock
            self.cancelBlock = cancelBlock
        }
        
        self.setupUI()
        
        
    }
    
    private func showInView(){
        if let window = self.jj_window {
            if model.showInType == .window {
                window.addSubview(self)
                return
            }else if model.showInType == .vc{
                if let vc = window.currentVC() {
                    self.jj_showInView = vc.view
                    vc.view.addSubview(self)
                    return
                }
            }else if model.showInType == .nc{
                if let nc = window.currentVC()?.navigationController {
                    self.jj_showInView = nc.view
                    nc.view.addSubview(self)
                    return
                }
            }
            
        }
    }
    
    private  func setupTopView() {
        
        var contentViewWidth = contentView.frame.size.width
        if contentViewWidth < 1 {
            contentViewWidth = self.getViewWidth()
        }
        self.topView.setup(frame: CGRect.init(x: 0, y: 0, width:contentViewWidth, height:0), config: model.topViewConfig)
        self.topView.clickCancelButton { [weak self](btn) in
            guard let weakSelf = self else {return}
            weakSelf.hidden()
            if let cancelBlock = weakSelf.cancelBlock{
                cancelBlock(weakSelf,btn)
            }
        }
        self.topView.clickConfirmButton { [weak self](btn) in
            guard let weakSelf = self else {return}
            if weakSelf.model.isConfirmHidden {
                weakSelf.hidden()
            }
            if let confirmBlock = weakSelf.confirmBlock{
                confirmBlock(weakSelf,btn)
            }
        }

    }
    
    
    open  func show() {
        if self.isAnimation {
            return
        }
        self.effectView?.removeFromSuperview()
        self.effectView = nil
        if self.model.blurEffectStyle == .none {
            self.backgroundColor = self.model.maskLayerColor
        }else{
            if let style = UIBlurEffect.Style.init(rawValue: self.model.blurEffectStyle.rawValue) {
                self.effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: style))
                self.effectView?.alpha = 0.85
                self.effectView?.frame = bounds
                self.insertSubview(self.effectView!, at: 0)
            }else{
                self.backgroundColor = self.model.maskLayerColor
            }
        }
        self.alpha = 0
        if animationType == .scale {
            self.popupView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }else if animationType == .move{
            self.popupView.transform = CGAffineTransform(translationX: 0, y: self.getViewHeight())
        }else{
            self.popupView.alpha = 0
        }
        self.animate(animations: { [weak self] in
            guard let weakSelf = self else {return}
            if weakSelf.animationType == .fade{
                self?.popupView.alpha = 1
            }else{
                weakSelf.popupView.transform = .identity
            }
            weakSelf.alpha = 1
        }, completion:nil)
    }
    
    @objc open func hidden() {
        if self.isAnimation {
            return
        }
        self.animate { [weak self] in
            guard let weakSelf = self else {return}
            if weakSelf.animationType == .move{
                weakSelf.popupView.transform = CGAffineTransform(translationX: 0, y: weakSelf.getViewHeight())
            }else{
                weakSelf.popupView.isHidden = true
            }
            weakSelf.alpha = 0
        } completion: { [weak self] in
            self?.removeFromSuperview()
        }
        
    }
    
    
    private func animate(animations: @escaping () -> Void, completion:(() -> Void)? = nil){
        self.isAnimation = true
        let usingSpringWithDamping:CGFloat = 0.8
        let initialSpringVelocity:CGFloat = 0.5
        let duration:Double = 0.3
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: animations) { (_) in
            self.isAnimation = false
            if let cm = completion {
                cm()
            }
        }
    }
    
    private func setupUI() {
        self.addSubview(self.popupView)
        self.backgroundColor = .clear
        self.popupView.backgroundColor = .clear
        if self.contentView.backgroundColor == nil || self.contentView.backgroundColor == .clear  {
            self.contentView.backgroundColor = model.backgroundColor
        }
        self.popupView.backgroundColor = model.backgroundColor
        self.popupView.addSubview(self.contentView)
        
        let contentViewHeight = max(contentView.frame.size.height, model.contentViewMinHeight)
        var topViewViewHeight:CGFloat = 0
        var popuViewWidth:CGFloat = self.contentView.frame.size.width
        if !model.topViewConfig.isHidden {
            topViewViewHeight = max(topView.frame.size.height, model.topViewConfig.minHeight)
            popuViewWidth = self.topView.frame.size.width
            self.popupView.addSubview(self.topView)
        }else{
            if popuViewWidth < 1 {
                popuViewWidth = self.getViewWidth()
            }
        }
        
        let popupViewHeight:CGFloat = contentViewHeight + topViewViewHeight
        self.popupView.frame = CGRect.init(x: 0, y: self.getViewHeight()-popupViewHeight, width:popuViewWidth, height: popupViewHeight)
        if animationType == .move {
            self.popupView.center = CGPoint.init(x: self.getViewWidth()/2.0, y: self.popupView.center.y)
            
        }else{
            self.popupView.center = CGPoint.init(x: self.getViewWidth()/2.0, y: self.getViewHeight()/2.0)
        }
        
        self.contentView.frame = CGRect.init(x: 0, y: topViewViewHeight-1, width: popuViewWidth, height:contentViewHeight+1)
        self.contentView.center = CGPoint.init(x: self.popupView.frame.size.width/2.0, y: self.contentView.center.y)
        //设置圆角
        self.setCornersRadius()
        
    }
    
    private func setCornersRadius(){
        let radius = model.popupViewRadius
        if radius > 0 {
            if model.animationType == .move {
                self.popupView.jj_setCornersRadius(radius: radius, roundingCorners: [.topLeft,.topRight])
            }else{
                self.popupView.jj_setCornersRadius(radius: radius, roundingCorners: [.allCorners])
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return model.isTouchHidden
        }
        //touchView的frame转化到popupView上的frame
        let frame = touchView.convert(touchView.frame, to: self.popupView)
        if frame.origin.x >= 0&&frame.origin.y >= 0 {
            //说明点击的是popupView上的视图
            return false
        }
        return model.isTouchHidden
    }
    
    private func getViewHeight() -> CGFloat {
        if let view = self.jj_showInView {
            return view.bounds.height
        }
        return UIScreen.main.bounds.height
    }
    
    private func getViewWidth() -> CGFloat {
        if let view = self.jj_showInView {
            return view.bounds.width
        }
        return UIScreen.main.bounds.width
    }
    
}


extension UIView {
    //设置圆角
    func jj_setCornersRadius(radius: CGFloat, roundingCorners: UIRectCorner) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.main.scale
        self.layer.mask = maskLayer
    }
    
}

extension UIWindow {
    
    static func current() -> UIWindow? {
        if #available(iOS 13, *) {
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive,let window = (scene as! UIWindowScene).windows.first {
                    return window
                }
            }
            if UIApplication.shared.windows.count > 0 {
                for window in UIApplication.shared.windows {
                    if window.isMember(of: UIWindow.self) {
                        return window
                    }
                }
            }
        }else{
            if let delegate = UIApplication.shared.delegate,let window = delegate.window,let w = window {
                return w
            }
        }
        return nil
    }
    
    func currentVC() -> UIViewController?{
        if let rootVC = self.rootViewController{
            return UIWindow.getCurrentVC(form: rootVC)
        }
        return nil
    }
    
    static func currentVC() -> UIViewController?{
        if let rootVC = self.current()?.rootViewController{
            return self.getCurrentVC(form: rootVC)
        }
        return nil
    }
    
    static private func getCurrentVC(form rootVC:UIViewController) -> UIViewController?{
        var currentVC:UIViewController? = nil
        var rootPre = rootVC
        if rootPre.presentedViewController != nil {
            rootPre = rootVC.presentedViewController!
        }
        if rootVC.isKind(of: UITabBarController.self) {
            if let selectedViewController = (rootVC as! UITabBarController).selectedViewController {
                currentVC = self.getCurrentVC(form: selectedViewController)
            }
        }else if rootVC.isKind(of: UINavigationController.self){
            if let visibleViewController = (rootVC as! UINavigationController).visibleViewController {
                currentVC = self.getCurrentVC(form: visibleViewController)
            }
        }else{
            currentVC = rootPre
        }
        return currentVC
    }
}
