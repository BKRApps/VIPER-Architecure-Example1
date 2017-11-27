//
//  ListInteractorIO.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ListInteractorInput:class {
    func getImagesFromFlickr(maxImages:Int)
}

protocol ListInteractorOutput:class {
    func postImagesFromFlicker(responseJson:JSON?,error:MTAppError?)
}
