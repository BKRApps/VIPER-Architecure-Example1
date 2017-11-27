//
//  AppDependencies.swift
//  MindGame
//
//  Created by Kumar Birapuram on 02/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies{
    
    var listWireframe=ListWireframe()
    
    init() {
        configureDepencies()
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        listWireframe.presentListFromWindow(window)
    }
    
    func configureDepencies(){
        let rootViewframe=RootWireframe()
        let listPresenter=ListPresenter()
        let listInteractor=ListInteractor()
        listWireframe.listPresenter=listPresenter
        listWireframe.rootWireframe=rootViewframe
        listPresenter.interactor=listInteractor
        listInteractor.output=listPresenter
    }
}
