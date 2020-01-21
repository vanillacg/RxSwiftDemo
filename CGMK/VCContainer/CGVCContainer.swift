//
//  CGVCContainer.swift
//  CGMK
//
//  Created by chenguang on 2019/5/14.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit

class CGVCContainer: CGViewContainer {
    private weak var parentVC : UIViewController?
    private var vcTitles:[String]?
    var contentVCs : [UIViewController] = [] {
        willSet (vcs) {
            var titles = [String]()
            var views = [UIView]()
            for vc in vcs {
                if vc.title != nil {
                    titles.append(vc.title!)
                }
                
                views.append(vc.view)
            }
            
            if (parentVC != nil && superview != nil) {
                for vc in contentVCs {
                    vc.willMove(toParent: nil)
                }
                for vc in vcs {
                    if (contentVCs.contains(vc)) {
                        continue
                    }
                    parentVC!.addChild(vc)
                }
            }
            contentViews = views
            if parentVC != nil && superview != nil {
                for vc in contentVCs {
                    if vcs .contains(vc) {
                        continue
                    }
                    vc .removeFromParent()
                }
                for vc in vcs {
                    vc .didMove(toParent: parentVC)
                }
            }

            topBar.vctitles = titles;
        }
    }
    
    public convenience init(frame: CGRect, parentVC vc: UIViewController) {
        self.init(frame: frame)
        parentVC = vc
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if parentVC != nil {
            if newSuperview != nil {
                for vc in contentVCs {
                    parentVC!.addChild(vc)
                }
            } else {
                for vc in contentVCs {
                    vc .willMove(toParent: nil)
                }
            }
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if parentVC != nil {
            if superview != nil {
                for vc in contentVCs {
                    vc .didMove(toParent: parentVC!)
                }
            } else {
                for vc in contentVCs {
                    vc .removeFromParent()
                }
            }
        }
    }
   
}
