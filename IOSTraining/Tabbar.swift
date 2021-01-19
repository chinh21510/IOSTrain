//
//  Tabbar.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/18/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
         let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(handleSwipes))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.items![0].title = "Discover"
        tabBar.items![0].image = UIImage(named: "menuTabbar")
        tabBar.items![1].title = "Search"
        tabBar.items![1].image = UIImage(named: "searchTabbar")
        tabBar.items![2].title = "Genres"
        tabBar.items![2].image = UIImage(named: "maskTabbar")
        tabBar.items![3].title = "Artists"
        tabBar.items![3].image = UIImage(named: "userTabbar")
        tabBar.tintColor = UIColor.systemTeal
    }
    
}
