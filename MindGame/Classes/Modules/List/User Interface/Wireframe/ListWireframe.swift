//
//  ListWireframe.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import UIKit

let ListViewControllerIdentifier="listVC"

class ListWireframe: NSObject {
    var listPresenter:ListPresenter?
    var rootWireframe:RootWireframe?
    var listViewController:ListViewController!
    
    func presentListFromWindow(_ window:UIWindow){
        listViewController=listViewControllerFromStoryboard()
        listViewController.eventHandler=listPresenter
        listPresenter?.userInterface=listViewController
        let navigationItem=listViewController.navigationItem
        navigationItem.title="MindGame"
        rootWireframe?.showRootViewController(listViewController, on: window)
    }
    
    func listViewControllerFromStoryboard()->ListViewController{
        let storyboard=UIStoryboard.init(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: ListViewControllerIdentifier) as! ListViewController
    }
}
