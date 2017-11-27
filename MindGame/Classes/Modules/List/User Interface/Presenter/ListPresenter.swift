//
//  ListPresenter.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListPresenter: NSObject,ListModuleInterface,ListInteractorOutput {
    weak var userInterface:ListViewInterface?
    var interactor:ListInteractorInput?
}

extension ListPresenter{
    func getImages(maxImages: Int) {
        interactor?.getImagesFromFlickr(maxImages: maxImages)
    }
    
    func getRandomNumber(models: [MindGameModel],limit:Int) {
        DispatchQueue.global(qos:.userInitiated).async{
            while(true){
                let randomInt=Int.randomIntFrom(start: 0, to: limit)
                let model=models[randomInt]
                if model.showImage{
                    continue
                }else{
                    self.userInterface?.postRandomNumber(randomNumber: randomInt)
                    break
                }
            }
        }
    }
    
    func validateSelection(randomModel: MindGameModel, against selectedModel: MindGameModel,models:[MindGameModel]) {
        var gameStatus=true
        if selectedModel==randomModel {
            selectedModel.showImage=true
            for model in models{
                if !model.showImage{
                    gameStatus=false
                    break
                }
            }
        }else{
            gameStatus=false
        }
        userInterface?.validatedSelection(isValidated: (selectedModel==randomModel),isGameOver: gameStatus)
    }
}

extension ListPresenter{
    func postImagesFromFlicker(responseJson: JSON?, error: MTAppError?) {
        if let resJson=responseJson{
            let dataManager=MindGameModelDataManager()
            let list=dataManager.prepareMindGameModels(json: resJson, limit: 9)
            userInterface?.postMindGameModels(models: list,error: nil)
        }else{
            userInterface?.postMindGameModels(models: nil,error: error)
        }
    }
}
