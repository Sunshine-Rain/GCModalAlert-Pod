//
//  GCBaseModalView.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

open class GCBaseModalAlert: UIView, Modalable {
    open var modalView: UIView {
        return self
    }
    
    open var modalViewLifecycle: ModalableLifecycleType? = nil
    
    open var modalViewConfig: ModalableConfig? = nil
    
    open var triggerDismiss: VoidClosure!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        basicSetup()
    }
    
    
    public init(frame: CGRect = .zero, lifecycle: ModalableLifecycle = ModalableLifecycle()) {
        self.modalViewLifecycle = lifecycle
        super.init(frame: frame)
        
        basicSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        basicSetup()
    }
    
    // Override point.
    open func basicSetup() {
        
    }
   
}
