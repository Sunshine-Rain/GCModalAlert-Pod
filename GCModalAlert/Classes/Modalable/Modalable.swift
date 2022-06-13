//
//  Modalable.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

public protocol Modalable: AnyObject {
    var modalView: UIView { get }
    var modalViewLifecycle: ModalableLifecycleType? { get set }
    var modalViewConfig: ModalableConfig? { get set }
    
    /// Modal alert call this closure to dismiss.
    var triggerDismiss: VoidClosure! { get set }
}

extension Modalable {
    public var identifier: String {
        return modalViewConfig?.duplicateIdentifier ?? NSStringFromClass(type(of: self))
    }
    
    public func stableConfig() -> ModalableConfig {
        return modalViewConfig ?? ModalableConfig.default
    }
}
