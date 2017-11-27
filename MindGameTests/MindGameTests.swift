//
//  MindGameTests.swift
//  MindGameTests
//
//  Created by Kumar Birapuram on 02/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import XCTest
@testable import MindGame

class MindGameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlickrApi(){
        let semaphore=DispatchSemaphore(value: 0)
        NetworkManager.makeANetworkCall(endpoint: "https://api.flickr.com/services/feeds/photos_public.gne?format=json"){ (data,response,error) in
            if let e=error{
                XCTFail("Error: \(e.getErrorMessage())")
            }else if let statusCode=(response as? HTTPURLResponse)?.statusCode{
                if statusCode==200{
                    semaphore.signal()
                }else{
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        if semaphore.wait(timeout: DispatchTime.now()+5)==DispatchTimeoutResult.timedOut{
            XCTFail("Failed to execute within time")
        }
    }
}
