//
//  MTAppError.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation

enum MTAppError:Error{
    case NetworkError
    case ErrorWithInfo(String)
    
    func getErrorMessage()->String{
        switch self {
        case .NetworkError:
            return " Please connect to internet and try again"
        case let .ErrorWithInfo(errorString):
            return errorString
        }
    }
}
