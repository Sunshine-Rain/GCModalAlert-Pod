//
//  GCModaManager.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

open class GCModalManager {
    public static let defaultManager = GCModalManager()
    
    open var modalObjects: [Modalable] = []
    open var backgroundView: GCModalBackground
    open var currentModal: Modalable?
    
    private let originalAlpha: CGFloat
    
    
    public init(_ bgView: GCModalBackground = GCModalBackground()) {
        originalAlpha = bgView.alpha
        backgroundView = bgView
        backgroundView.tapAction = { [unowned self] in
            self.actionTap()
        }
    }
    
    open func executeOnMainThread(task: @escaping VoidClosure) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                task()
            }
            return
        }
        
        task()
    }
    
    open func add(_ modal: Modalable) {
        executeOnMainThread {
            self.addModalIfNeeded(modal: modal)
            self.showModalIfNeeded()
        }
    }
    
    open func showModalIfNeeded() {
        // if is showing another
        guard currentModal == nil, let modal = getNeedShowModal() else {
            return
        }
        
        // condition testing
        guard modal.modalViewConfig.condition?() ?? true else {
            showModalIfNeeded()
            return
        }
        
        //
        setupBackgroundViewIfNeeded()
        
        // will show
        currentModal = modal
        modal.modalViewLifecycle.modalViewWillShow?()
        backgroundView.addSubview(modal.modalView)
        
        // animations
        showAnimation(for: modal) { _ in
            // did show
            modal.modalViewLifecycle.modalViewDidShow?()
        }
    }
    
    open func setupBackgroundViewIfNeeded() {
        assert(UIApplication.shared.keyWindow != nil, "KeyWindow not found!")
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        if backgroundView.superview != keyWindow {
            backgroundView.removeFromSuperview()
            backgroundView.frame = keyWindow.bounds
            keyWindow.addSubview(backgroundView)
        }
    }
    
    open func removeBackgroundIfNeeded() {
        if modalObjects.isEmpty {
            backgroundView.removeFromSuperview()
        }
    }
    
    open func addModalIfNeeded(modal: Modalable) {
        let config = modal.modalViewConfig
        let currentIdentifier = modal.identifier
        
        // ignoreLatest
        if config.beahviorWhileDuplicate == .ignoreLatest,
           (currentModal?.identifier == currentIdentifier
            || modalObjects.firstIndex(where: { $0.identifier == currentIdentifier }) != nil) {
            return
        }
        
        // useLastest
        if config.beahviorWhileDuplicate == .useLastest {
            modalObjects.removeAll { currentIdentifier == $0.identifier }
        }
        
        // normal
        modal.triggerDismiss = self.triggerDismiss
        modalObjects.append(modal)
        modalObjects.sort { $0.modalViewConfig.priority > $1.modalViewConfig.priority }
        showModalIfNeeded()
    }
    
    open func getNeedShowModal() -> Modalable? {
        // get the modal view by priority
        guard modalObjects.count > 0 else {
            return nil
            
        }
        return modalObjects.removeFirst()
    }
    
    open func triggerDismiss() {
        assert(Thread.isMainThread, "Modal dismiss should be executed on main thread.")
        // will dismiss
        currentModal?.modalViewLifecycle.modalViewWillDisappear?()
        
        // animations
        disappearAnimation(for: currentModal) { [weak self] _ in
            assert(Thread.isMainThread, "Animations finish closure should be executed on main thread.")
            if let self = self {
                // did dismiss
                self.currentModal?.modalView.removeFromSuperview()
                self.currentModal?.modalViewLifecycle.modalViewDidDisappear?()
                self.currentModal = nil
                self.removeBackgroundIfNeeded()
                
                // show next
                self.showModalIfNeeded()
            }
        }
    }
    
    // MARK: Actions
    open func actionTap() {
        guard let current = currentModal else {
            return
        }
        
        current.modalViewConfig.tapBackgroundClosure?()
        if current.modalViewConfig.cancelWhileTapBackground {
            triggerDismiss()
        }
    }
    
    
    // MARK: Animations
    open func showAnimation(for modal: Modalable, completion: @escaping BoolClosure) {
        // custom animations
        if modal.modalViewConfig.showAnimationClosure != nil {
            modal.modalViewConfig.showAnimationClosure?(backgroundView, modal, completion)
            return
        }
        
        //
        let config = modal.modalViewConfig
        switch config.showAnimationType {
        case .fade:
            backgroundView.alpha = 0.0
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.alpha = self.originalAlpha
            } completion: { finished in
                completion(finished)
            }
        case .B2T:
            let originFrame = modal.modalView.frame
            let frameBegin = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.alpha = 0.0
            modal.modalView.frame = frameBegin
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.alpha = self.originalAlpha
                modal.modalView.frame = originFrame
            } completion: { finished in
                completion(finished)
            }
        }
    }
    
    open func disappearAnimation(for modal: Modalable?, completion: @escaping BoolClosure) {
        guard let modal = modal else {
            return
        }
        
        // custom animations
        if modal.modalViewConfig.dismissAnimationClosure != nil {
            modal.modalViewConfig.dismissAnimationClosure?(backgroundView, modal, completion)
            return
        }
        
        //
        let config = modal.modalViewConfig
        switch config.dismissAnimationType {
        case .fade:
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.alpha = 0.0
                modal.modalView.alpha = 0.0
            } completion: { finished in
                self.backgroundView.alpha = self.originalAlpha
                completion(finished)
            }
        case .T2B:
            let originFrame = modal.modalView.frame
            let frameEnd = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.alpha = self.originalAlpha
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.alpha = 0.0
                modal.modalView.frame = frameEnd
            } completion: { finished in
                self.backgroundView.alpha = self.originalAlpha
                completion(finished)
            }
        }
    }
}
