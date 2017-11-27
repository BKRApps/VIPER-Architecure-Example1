//
//  ListModuleInterface.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation

protocol ListModuleInterface:class {
    func getImages(maxImages:Int)
    func getRandomNumber(models:[MindGameModel],limit:Int)
    func validateSelection(randomModel:MindGameModel,against selectedModel:MindGameModel,models:[MindGameModel])
}
