//
//  BottomPushModal.swift
//  GCModalAlert_Example
//
//  Created by quan on 2021/9/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import GCModalAlert

class BottomPushModal: GCBaseModalAlert {
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let titleLabel: UILabel = UILabel()
    
    private let labelHeight: CGFloat = 44.0
    private let foods = ["Apple", "Orange", "Banana", "Pineapple", "Rice", "Beaf", "KFC", "Snacks"]
    
    var selectedBlock: ((String) -> Void)?
    
    override init(frame: CGRect = .zero, lifecycle: ModalableLifecycle = ModalableLifecycle()) {
        super.init(frame: frame, lifecycle: lifecycle)
        setupViews()
        modalViewConfig.showAnimationType = .B2T
        modalViewConfig.dismissAnimationType = .T2B
        modalViewConfig.cancelWhileTapBackground = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = "Please choose your Favourite food"
        self.addSubview(titleLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        var frame = self.bounds
        frame.origin.y = labelHeight
        frame.size.height -= labelHeight
        tableView.frame = frame
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.size.width - 20, height: labelHeight)
    }
    
    deinit {
        print("deinit BottomPushModal ...")
    }
}

extension BottomPushModal: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = foods[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = foods[indexPath.row]
        
        print("Your Favourite food is \(item)")
        selectedBlock?(item)
        triggerDismiss()
    }
    
}
