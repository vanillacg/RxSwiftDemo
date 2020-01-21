//
//  CGTabBarController.swift
//  CGMK
//
//  Created by chenguang on 2019/5/10.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit

class CGTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildController(ChildController: CGHomeViewController(), Title: "首页", DefaultImage: UIImage.init(named:"home")!, SelectedImage: UIImage.init(named:"home")!)
        addChildController(ChildController: CGMineViewController(), Title: "手记", DefaultImage: UIImage.init(named: "favor")!, SelectedImage: UIImage.init(named: "favor")!)
        addChildController(ChildController: CGNoteViewController(), Title: "我的学习", DefaultImage: UIImage.init(named: "find")!, SelectedImage: UIImage.init(named: "find")!)
        addChildController(ChildController: CGAccountViewController(), Title: "账号", DefaultImage: UIImage.init(named: "me")!, SelectedImage: UIImage.init(named: "me")!)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func addChildController(ChildController child:UIViewController, Title title:String, DefaultImage defaultImage:UIImage, SelectedImage selectedImage:UIImage) -> Void {
        child.tabBarItem = UITabBarItem.init(title: title, image: defaultImage, selectedImage: selectedImage)
        let nav = UINavigationController(rootViewController: child)
        nav.setNavigationBarHidden(true, animated: true)
        addChild(nav)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
