//
//  ViewController.swift
//  GCModalAlert
//
//  Created by 1137576021@qq.com on 09/01/2021.
//  Copyright (c) 2021 1137576021@qq.com. All rights reserved.
//

import UIKit
import GCModalAlert

@inline(__always) func kScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

class ViewController: UIViewController {
    
    var modal: GCBaseModalAlert!
    
    var modal2: GCBaseModalAlert!
    
    var modal3: GCBaseModalAlert!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let attentions = UILabel(frame: .init(x: 0, y: 0, width: 100, height: 40))
        attentions.text = "attentions"
        view.addSubview(attentions)
        
        let frame = CGRect(x: (kScreenWidth() - 200) / 2, y: 100, width: 200, height: 320)
        let lifecycle = ModalableLifecycle {
            print("willShow ..")
        } didShow: {
            print("didShow ..")
        } willDisappear: {
            print("willDisappear ..")
        } didDisappear: {
            print("didDisappear ..")
        }

        
        // life cycle
        modal = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal.backgroundColor = .orange
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal.addGestureRecognizer(tap)
        
        // basic
        modal3 = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal3.backgroundColor = .cyan
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal3.addGestureRecognizer(tap3)
        modal3.modalViewConfig.duplicateIdentifier = "modal3"
        
        // using config
        modal2 = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal2.backgroundColor = .green
        modal2.modalViewConfig = ModalableConfig(
            priority: 10,
            condition: {
                return 1 > 0
            },
            beahviorWhileDuplicate: .useLastest,
            duplicateIdentifier: "000000",
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
        modal2.addGestureRecognizer(tap2)
    
        
        DispatchQueue.main.async {
            GCModalManager.defaultManager.add(self.modal)
            GCModalManager.defaultManager.add(self.modal3)
            GCModalManager.defaultManager.add(self.modal2)
        }
    }
    
    @objc func dismissAction(sender: UITapGestureRecognizer) {
        (sender.view as! Modalable).triggerDismiss?()
    }

}

