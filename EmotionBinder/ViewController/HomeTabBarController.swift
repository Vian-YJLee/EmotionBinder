//
//  HomeTabBarController.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 24/07/2019.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let index = tabBarController.viewControllers?.index(of: viewController) else {
            return true
        }
        
        if index == ViewControllerIndex.cameraView {
            
            self.performSegue(withIdentifier: HomeTabBarController.showCameraSegueIdentifier, sender: self)
            
            return false
        }
        return true
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

extension HomeTabBarController {
    
    fileprivate struct ViewControllerIndex {
        static let main = 0
        static let cameraView = 1
        static let account = 2
    }
    
    fileprivate static let showCameraSegueIdentifier = "showCameraView"
}
    

extension HomeTabBarController {
    static func someTypeMethod () {
        
    }
}
