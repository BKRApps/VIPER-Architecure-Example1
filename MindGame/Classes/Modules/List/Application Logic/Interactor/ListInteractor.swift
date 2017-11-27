//
//  ListInteractor.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import SwiftyJSON

let FlickrEndpoint="https://api.flickr.com/services/feeds/photos_public.gne?format=json"

class ListInteractor: NSObject,ListInteractorInput {
    weak var output:ListInteractorOutput?
}

extension ListInteractor{
    func getImagesFromFlickr(maxImages: Int) {
        var headerParams=[String:AnyObject]()
        headerParams["Content-Type"]="application/json" as AnyObject
        NetworkManager.makeANetworkCall(endpoint: FlickrEndpoint,headerParams: headerParams){[weak self](data,response,error) in
            let unknownError="unable to retrive contacts right now. please try again later."
            if let e=error{
                self?.output?.postImagesFromFlicker(responseJson: nil, error: e)
            }else if let responseData=data{
                do{
                    if var jsonString=String(data: responseData, encoding: String.Encoding.utf8){
                        if jsonString.contains("jsonFlickrFeed("){
                            jsonString = jsonString.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
                            let index=jsonString.characters.index(before: jsonString.characters.endIndex)
                            jsonString.characters.remove(at: index)
                        }
                        if let jData=jsonString.data(using: String.Encoding.utf8){
                            let jsonResponse=try JSON(data: jData)
                            self?.output?.postImagesFromFlicker(responseJson: jsonResponse, error: nil)
                            return
                        }
                    }
                    self?.output?.postImagesFromFlicker(responseJson: nil, error: MTAppError.ErrorWithInfo(unknownError))
                }catch{
                     self?.output?.postImagesFromFlicker(responseJson: nil, error: MTAppError.ErrorWithInfo(error.localizedDescription))
                }
            }else{
                 self?.output?.postImagesFromFlicker(responseJson: nil, error: MTAppError.ErrorWithInfo(unknownError))
            }
        }
    }
}
