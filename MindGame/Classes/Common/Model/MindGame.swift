//
//  MindGame.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import SwiftyJSON

class MindGameModel {
    let imageUrl:String
    var showImage:Bool
    let quizImage:String
    
    init(imageUrl:String,showImage:Bool) {
        self.imageUrl=imageUrl
        self.showImage=showImage
        self.quizImage="quizImage"
    }
}

extension MindGameModel{
    static func ==(leftSide:MindGameModel,rightSide:MindGameModel)->Bool{
        if leftSide.imageUrl == rightSide.imageUrl {
            return true
        }
        return false
    }
}

class MindGameModelDataManager: NSObject {
    func prepareMindGameModels(json:JSON,limit:Int)->[MindGameModel]{
        var mindGameModels=[MindGameModel]()
        let itemArray=json["items"]
        if let items=itemArray.array{
            for item in items{
                if mindGameModels.count==limit {
                    break
                }
                let mediaInfo=item["media"]
                if let link=mediaInfo["m"].string{
                    let model=MindGameModel(imageUrl: link, showImage: true)
                     mindGameModels.append(model)
                }
            }
        }
        return mindGameModels
    }
}
