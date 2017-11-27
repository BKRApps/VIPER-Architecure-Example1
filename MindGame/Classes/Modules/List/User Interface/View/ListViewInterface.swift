//
//  ListViewInterface.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation

protocol ListViewInterface:class {
    func postMindGameModels(models:[MindGameModel]?,error:MTAppError?)
    func postRandomNumber(randomNumber:Int)
    func validatedSelection(isValidated:Bool,isGameOver:Bool)
}
