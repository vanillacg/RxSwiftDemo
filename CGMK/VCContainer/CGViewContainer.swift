//
//  CGViewContainer.swift
//  CGMK
//
//  Created by chenguang on 2019/5/15.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit

@objc protocol CGViewContainerProtocal {
    @objc optional func CGViewContainerBeginDrag(CGViewContainer viewContainer:CGViewContainer)->Void
    @objc optional func CGViewContainerDidSelectIndex(selectIndex index:Int)->Void
}

class CGViewContainer: UIView,UIScrollViewDelegate {
    var contentCount:Int = 0
    
    weak var delegate:CGViewContainerProtocal?
    var contentViews:[UIView] = [] {
        willSet (views) {
            for view in contentViews {
                view .removeFromSuperview()
            }
            for view in views {
                scrollView.addSubview(view)
            }
        }
    }
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        return scrollView
    }()
    lazy var topBar:CGVCContainerBar = {
        let topBar = CGVCContainerBar()
        topBar.delegate = self
        return topBar
    }()
    var topBarHeight:Int
    var topBarOffsetY = 0
    
    override init(frame: CGRect) {
        topBarHeight = (Int)(CGNavigatorHeight)
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(topBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = Int(bounds.width)
        topBar.frame = CGRect(x:0, y: topBarOffsetY, width: viewWidth,height: topBarHeight)
        let scrollViewHeight = Int(bounds.height) - topBarHeight - topBarOffsetY
        scrollView.frame = CGRect(x:0, y: topBarHeight + topBarOffsetY,width: viewWidth,height: scrollViewHeight)
        scrollView.contentSize = CGSize(width: viewWidth * contentViews.count, height: scrollViewHeight)
        scrollView.contentOffset = CGPoint(x: topBar.selectIndex, y: 0)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
//            automaticallyAdjustsScrollViewInsets = false;
        };
        for index in 0..<(contentViews.count) {
            let contentView = contentViews[index]
            contentView.frame = CGRect(x: viewWidth * index, y: 0, width: viewWidth, height: scrollViewHeight)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.CGViewContainerBeginDrag?(CGViewContainer: self)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topBar.updateIndictor(scrollView.contentOffset.x/scrollView.contentSize.width)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        topBar.setSelectedIndex((Int)(scrollView.contentOffset.x/scrollView.bounds.width), false) 
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
}

//MARK : CGViewContainerProtocal
extension CGViewContainer : CGVCContainerBarPrococol {
    
    func didChangeSelectIndex(selectedIndex index: Int, _ animated:Bool) {
        if animated {
            self.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.isUserInteractionEnabled = true
            }
        }
        scrollView.setContentOffset(CGPoint(x: index * (Int)(scrollView.bounds.width), y: 0), animated: animated)
        delegate?.CGViewContainerDidSelectIndex?(selectIndex: index)
    }
}
