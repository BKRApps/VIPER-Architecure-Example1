//
//  RootWireframe.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import UIKit

class RootWireframe: NSObject {
    func showRootViewController(_ viewController:UIViewController,on window:UIWindow){
        let navigationController=window.rootViewController as! UINavigationController
        navigationController.viewControllers=[viewController]
    }
}
