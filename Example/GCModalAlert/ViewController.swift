//
//  ViewController.swift
//  GCModalAlert
//
//  Created by 1137576021@qq.com on 09/01/2021.
//  Copyright (c) 2021 1137576021@qq.com. All rights reserved.
//

import UIKit
import GCModalAlert

@inline(__always) public func kScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

@inline(__always) public func kScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

class ViewController: UIViewController {
    
    private let favouriteFoodBtn: UIButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GCModalManager.defaultManager.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        var yOffset: CGFloat = 100.0
        let btnHeight: CGFloat = 65.0
        favouriteFoodBtn.frame = CGRect(x: 0, y: yOffset, width: kScreenWidth(), height: btnHeight)
        favouriteFoodBtn.backgroundColor = .orange
        favouriteFoodBtn.setTitle("Choose Favourite", for: .normal)
        favouriteFoodBtn.addTarget(self, action: #selector(chooseFavourite(_:)), for: .touchUpInside)
        view.addSubview(favouriteFoodBtn)
        
        // life cycle
        yOffset += (10 + btnHeight)
        let lifecycleTestBtn = UIButton(type: .custom)
        lifecycleTestBtn.tag = 1
        lifecycleTestBtn.frame = CGRect(x: 0, y: yOffset, width: kScreenWidth(), height: 65)
        lifecycleTestBtn.backgroundColor = .orange
        lifecycleTestBtn.setTitle("LifeCycle", for: .normal)
        lifecycleTestBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        view.addSubview(lifecycleTestBtn)
        
        
        //  basic use
        yOffset += (10 + btnHeight)
        let basicUse = UIButton(type: .custom)
        basicUse.tag = 2
        basicUse.frame = CGRect(x: 0, y: yOffset, width: kScreenWidth(), height: 65)
        basicUse.backgroundColor = .orange
        basicUse.setTitle("Basic Use", for: .normal)
        basicUse.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        view.addSubview(basicUse)
        
        // other configs
        yOffset += (10 + btnHeight)
        let otherConfigBtn = UIButton(type: .custom)
        otherConfigBtn.tag = 3
        otherConfigBtn.frame = CGRect(x: 0, y: yOffset, width: kScreenWidth(), height: 65)
        otherConfigBtn.backgroundColor = .orange
        otherConfigBtn.setTitle("Other configs", for: .normal)
        otherConfigBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        view.addSubview(otherConfigBtn)
        
    }
    
    @objc func dismissAction(sender: UITapGestureRecognizer) {
        (sender.view as! Modalable).triggerDismiss?()
    }
    
    @objc func btnAction(_ sender: UIButton) {
        let frame = CGRect(x: (kScreenWidth() - 200) / 2, y: 100, width: 200, height: 320)
        switch sender.tag {
        case 1:
            // lifecycle
            let lifecycle = ModalableLifecycle {
                print("willShow ..")
            } didShow: {
                print("didShow ..")
            } willDisappear: {
                print("willDisappear ..")
            } didDisappear: {
                print("didDisappear ..")
            }
            
            let modalAlert = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
            modalAlert.backgroundColor = .purple
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
            modalAlert.addGestureRecognizer(tap)
            GCModalManager.defaultManager.add(modalAlert)
            
        case 2:
            // basic use
            let alert = GCBaseModalAlert(frame: frame)
            alert.backgroundColor = .cyan
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
            alert.addGestureRecognizer(tap3)
            alert.modalViewConfig.duplicateIdentifier = "basic use"
            GCModalManager.defaultManager.add(alert)
        case 3:
            // configs
            let alert = GCBaseModalAlert(frame: frame)
            alert.backgroundColor = .green
            alert.modalViewConfig = ModalableConfig(
                priority: 10,
                condition: {
                    return 1 > 0
                },
                beahviorWhileDuplicate: .useLastest,
                duplicateIdentifier: "other configs",
                cancelWhileTapBackground: true,
                tapBackgroundClosure: {
                    print("tap modal2 Background.")
                },
                showAnimationType: .B2T,
                showAnimationClosure: { bg, modal, completion  in
                    // custom animation
                    let animation = CABasicAnimation(keyPath: "transform.scale")
                    animation.fromValue = NSNumber.init(value: 1.2)
                    animation.toValue = NSNumber.init(value: 1.0)
                    animation.duration = 0.25
                    
                    modal.modalView.layer.add(animation, forKey: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        completion(true)
                    }
                },
                dismissAnimationType: .T2B)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
            alert.addGestureRecognizer(tap2)
            GCModalManager.defaultManager.add(alert)
        default:
            break
        }
    }
    
    @objc func chooseFavourite(_ btn: UIButton) {
        let alert = BottomPushModal()
        let height: CGFloat = 400
        alert.frame = CGRect(x: 0, y: kScreenHeight() - height, width: kScreenWidth(), height: height)
        alert.selectedBlock = { food in
            self.favouriteFoodBtn.setTitle("Favourite is \(food)", for: .normal)
        }
        
        
        GCModalManager.defaultManager.add(alert)
    }

}

