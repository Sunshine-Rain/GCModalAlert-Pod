//
//  SimplestAlert.swift
//  GCModalAlert_Example
//
//  Created by quan on 2022/6/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import GCModalAlert

class SimplestAlert: GCBaseModalAlert {
    override func basicSetup() {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.text = "I am SimplestAlert.\n(Orange background color with 0.3 alpha.)"
        
        var config = ModalableConfig()
        config.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        config.cancelWhileTapBackground = false
        modalViewConfig = config
    }
}
