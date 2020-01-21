//
//  CGVCContainerBar.swift
//  CGMK
//
//  Created by chenguang on 2019/5/14.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit

protocol CGVCContainerBarPrococol : NSObjectProtocol {
    func didChangeSelectIndex(selectedIndex index:Int, _ animated:Bool) -> Void
}

class CGVCContainerBar: UIView {
    weak var delegate:CGVCContainerBarPrococol?
    var selectIndex: Int = 0 
    var vctitles:[String] = [] {
        willSet (titles) {
            for btn in itemButtons {
                btn.isHidden = true
            }
            for (i, title) in titles.enumerated() {
                var btn:UIButton
                if i < itemButtons.count {
                    btn = itemButtons[i]
                    btn.isHidden = false
                } else {
                    btn = UIButton(type: .custom)
                    btn.setTitleColor(mainColor, for: .highlighted)
                    btn.titleLabel?.font = titleFont
                    btn.tag = i;
                    btn.addTarget(self, action: #selector(selectAction(btn:)), for: .touchUpInside)
                    scrollView.addSubview(btn)
                    itemButtons.append(btn)
                }
                if i != selectIndex {
                    btn.setTitleColor(grayColor, for: .normal)
                } else {
                    btn.setTitleColor(mainColor, for: .normal)
                }
                btn.setTitle(title, for: .normal)
            }
            scrollView.bringSubviewToFront(selectorIndicator)
        }
        didSet {
        }
    }
    var titleFont = UIFont.systemFont(ofSize: 16)
    
    var itemButtons:[UIButton] = []
    var leftPadding = 0
    var rightPadding = 0
    var topPadding = 20
    var itemWidth = 0
    var itemPadding:Int
    var buttonColor:UIColor?
    var buttonUnColor:UIColor?
    var mainColor:(UIColor) {
        return UIColor(red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
    }
    var grayColor:(UIColor) {
        return UIColor(white: 66.0/255, alpha: 1.0)
    }
    var expectedWidth:Int? {
        willSet (width) {
        }
        
    }
    override init(frame: CGRect) {
        itemPadding = 20
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        let barWidth = (Int)(bounds.width)
        let barHeight = (Int)(bounds.height)
        let scrollViewWidth = barWidth - leftPadding - rightPadding
        let scrollViewHeight = barHeight - topPadding
        
        layoutItems(CGSize(width: scrollViewWidth, height: scrollViewHeight))
        if Int(scrollView.contentSize.width) < scrollViewWidth {
            let center = scrollView.center
            scrollView.frame = CGRect(x: 0, y: 0, width: (Int)(scrollView.contentSize.width), height: scrollViewHeight)
            scrollView.center = center
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
    func layoutItems(_ size:CGSize) -> Void {
        scrollView.frame = CGRect(x: leftPadding, y: topPadding, width: (Int)(size.width), height: (Int)(size.height))
        var btnWidthTotal = 0
        let fontArrDict = [NSAttributedString.Key.font: titleFont]
        for (i, btn) in itemButtons.enumerated() {
            let title = vctitles[i]
            let width = (Int)((title as NSString).size(withAttributes: fontArrDict).width) + itemPadding
            btn.frame = CGRect(x: btnWidthTotal, y: 0, width: width, height: (Int)(size.height))
            if selectIndex == i {
                selectorIndicator.frame = CGRect(x: 10, y: (Int)(size.height) - 3, width: width, height: 3)
                selectorIndicator.layer.cornerRadius = 2
            }
            btnWidthTotal += width
        }
        scrollView.contentSize = CGSize(width: btnWidthTotal, height: (Int)(size.height))

        
    }
    @objc func selectAction(btn selectedBtn:UIButton) -> Void {
        if selectedBtn.tag != selectIndex {
            setSelectedIndex(selectedBtn.tag, false)
        }
    }

    
    lazy var scrollView:UIScrollView = {
      let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    lazy var selectorIndicator:UIView = {
        let selectorIndicator = UIView.init()
        selectorIndicator.backgroundColor = UIColor.white
        return selectorIndicator
    }()
    lazy var bottomLine:UIView = {
       let bottomLine = UIView.init()
        bottomLine.backgroundColor = UIColor(white: 231.0/255, alpha: 1.0)
        return bottomLine
    }()
    func updateIndictor(_ progress: CGFloat) -> Void {
        if progress != progress {
            return
        }
        if scrollView.contentSize.width == 0 {
            return
        }
        var frame = selectorIndicator.frame
        frame.origin.x = scrollView.contentSize.width * progress
        selectorIndicator.frame = frame;
        if scrollView.isScrollEnabled == false {
            let itemCount = itemButtons.count
            let offsetProgress = progress * (CGFloat)(itemCount / (itemCount - 1))
            let newOffset = CGPoint(x: (scrollView.contentSize.width - scrollView.bounds.width) * offsetProgress, y: 0.0)
            scrollView.contentOffset = newOffset
        }
    }
    
    func setSelectedIndex(_ selected:Int, _ animated:Bool) -> Void {
        if selected < itemButtons.count && selected != selectIndex {
            var btn = itemButtons[selectIndex]
            btn .setTitleColor(grayColor, for: .normal)
            btn = itemButtons[selected]
            btn .setTitleColor(mainColor, for: .normal)
            selectIndex = selected
            delegate?.didChangeSelectIndex(selectedIndex: selected, animated)
        }
    }
}
