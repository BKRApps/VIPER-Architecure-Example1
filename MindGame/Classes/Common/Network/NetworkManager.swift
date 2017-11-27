//
//  NetworkManager.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import Foundation

enum HttpRequestMethod:String{
    case Get="GET"
    case Post="POST"
    case Put="PUT"
    case Delete="DELETE"
}

class NetworkManager {
    class func makeANetworkCall(endpoint:String,headerParams:[String:AnyObject]?=nil,bodyParams:[String:AnyObject]?=nil,requestMethod:HttpRequestMethod?=HttpRequestMethod.Get,timeout:TimeInterval=90,completionHandler:@escaping(Data?,URLResponse?,MTAppError?)->()){
        let request=MTURLSessionHelper.sharedSession.prepareRequest(endpoint: endpoint, headerParams: headerParams, bodyParams: bodyParams, requestMethod: requestMethod, timeout: timeout, completionHandler: completionHandler)
        MTURLSessionHelper.sharedSession.urlSession.dataTask(with: request!){ (data,response,error) in
            if let e=error{
                let code=(e as NSError).code
                let desc=(e as NSError).localizedDescription
                switch(code){
                case -1009:
                    completionHandler(data,response,MTAppError.NetworkError)
                default:
                    completionHandler(data,response,MTAppError.ErrorWithInfo(desc))
                }
            }else{
                completionHandler(data,response,nil)
            }}.resume()
    }
}

protocol MTURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession:MTURLSession {}

class MTURLSessionHelper{
    static let sharedSession=MTURLSessionHelper()
    var urlSession:MTURLSession!
    
    private init(){
        let config=URLSessionConfiguration.default
        urlSession=URLSession(configuration: config)
    }
    
    func prepareRequest(endpoint:String,headerParams:[String:AnyObject]?,bodyParams:[String:AnyObject]?,requestMethod:HttpRequestMethod?,timeout:TimeInterval,completionHandler:@escaping(Data?,URLResponse?,MTAppError?)->())->URLRequest?{
        guard let endpointURL=URL(string: endpoint) else {
            completionHandler(nil,nil,MTAppError.ErrorWithInfo("unable to reach our servers"))
            return nil
        }
        var request=URLRequest(url: endpointURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        if let reqMethod=requestMethod{
            request.httpMethod=reqMethod.rawValue
        }else{
            request.httpMethod=HttpRequestMethod.Get.rawValue
        }
        if let hParams=headerParams{
            for (key,value) in hParams {
                request.addValue(value as! String, forHTTPHeaderField: key)
            }
        }
        if let requestType=headerParams?["Content-Type"] as? String,let bParams=bodyParams {
            if requestType == "application/json" {
                do{
                    let data=try JSONSerialization.data(withJSONObject: bParams, options: .prettyPrinted)
                    request.httpBody=data
                }catch let error as NSError{
                    print("unable to form json \(error.userInfo)")
                    completionHandler(nil,nil,MTAppError.ErrorWithInfo("unable to reach our servers"))
                    return nil
                }
            }
        }
        return request
    }
}


class URLSessionMock:MTURLSession{
    
    var data:Data?
    var request:URLRequest?
    var reponse:HTTPURLResponse?
    private var mockDataTask:URLSessionDataTaskMock!
    
    init(data:Data?=nil,resposne:URLResponse?=nil,error:Error?=nil) {
        mockDataTask=URLSessionDataTaskMock()
        mockDataTask.taskResponse=(data,resposne,error)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request=request
        mockDataTask.completionHandler=completionHandler
        return mockDataTask
    }
    
    private class URLSessionDataTaskMock:URLSessionDataTask{
        typealias CompletionHandler = (Data?,URLResponse?,Error?) -> Void
        var completionHandler:CompletionHandler?
        var taskResponse:(Data?,URLResponse?,Error?)?
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.taskResponse?.0,self.taskResponse?.1,self.taskResponse?.2)
            }
        }
    }
}
