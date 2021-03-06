# GCModalAlert

[![CI Status](https://img.shields.io/travis/1137576021@qq.com/GCModalAlert.svg?style=flat)](https://travis-ci.org/1137576021@qq.com/GCModalAlert)
[![Version](https://img.shields.io/cocoapods/v/GCModalAlert.svg?style=flat)](https://cocoapods.org/pods/GCModalAlert)
[![License](https://img.shields.io/cocoapods/l/GCModalAlert.svg?style=flat)](https://cocoapods.org/pods/GCModalAlert)
[![Platform](https://img.shields.io/cocoapods/p/GCModalAlert.svg?style=flat)](https://cocoapods.org/pods/GCModalAlert)

## Brief

GCModalAlert is a simple modal alert manager for iOS. It contains the following features:

* Auto manage custom alert views(Just add to manager ```GCModalManager.defaultManager.add(alert)```).
* Plenty of custom configs(See **ModalableConfig**).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GCModalAlert is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GCModalAlert'
```

## Preview

![image](https://github.com/Sunshine-Rain/GCModalAlert-Pod/blob/main/Example/GCModalAlert/preview.gif?raw=true)

## Usage

#### step 1.  Create a custom view inherited from GCBaseModalAlert or a custom object implements Modalable.

```
class BottomPushModal: GCBaseModalAlert {
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let titleLabel: UILabel = UILabel()
    
    private let labelHeight: CGFloat = 44.0
    private let foods = ["Apple", "Orange", "Banana", "Pineapple", "Rice", "Beaf", "KFC", "Snacks"]
    
    var selectedBlock: ((String) -> Void)?
    
    override init(frame: CGRect = .zero, lifecycle: ModalableLifecycle = ModalableLifecycle()) {
        super.init(frame: frame, lifecycle: lifecycle)
        setupViews()
        
        var config = ModalableConfig()
        config.showAnimationType = .B2T
        config.dismissAnimationType = .T2B
        config.cancelWhileTapBackground = true
        modalViewConfig = config
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
```

#### step 2.  Create the modal alert

```
let alert = BottomPushModal()
let height: CGFloat = 400
alert.frame = CGRect(x: 0, y: kScreenHeight() - height, width: kScreenWidth(), height: height)
alert.selectedBlock = { food in
    self.favouriteFoodBtn.setTitle("Favourite is \(food)", for: .normal)
}
```

#### step 3.  Add the modal alert to a manager

```
GCModalManager.defaultManager.add(alert)
```

## Author

1137576021@qq.com, 1137576021@qq.com

## License

GCModalAlert is available under the MIT license. See the LICENSE file for more info.
