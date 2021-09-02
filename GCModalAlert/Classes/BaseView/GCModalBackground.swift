//
//  GCModalBackground.swift
//  GCModalAlert
//
//  Created by quan on 2021/9/2.
//

import UIKit

open class GCModalBackground: UIView, UIGestureRecognizerDelegate {
    private var tapGes: UITapGestureRecognizer!
    open var tapAction: VoidClosure?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {
        tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tapGes.delegate = self
        self.addGestureRecognizer(tapGes)
    }
    
    @objc open func tapAction(_ sender: Any) {
        tapAction?()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
}
