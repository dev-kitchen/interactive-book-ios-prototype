//
//  RequestManager.swift
//  icf-books
//
//  Created by Andreas Plüss on 05.05.16.
//  Copyright © 2016 devkitchen. All rights reserved.
//

import Foundation

class RequestManager {
    
    static private let uri = Api.getLanguageUrl()
    
    // get all books
    static func getBooks(completionHandler: (books:NSDictionary?, error:RequestError?) -> (Void)) {
        
        //get specific request
        if let request = httpGetOn("/books") {
            //get data
            getDataFromRequest(request, callback: {retrievedData, errorMessage -> Void in
                
                var books:NSDictionary? = nil
                
                //if no error, bring the data in needed shape
                if errorMessage == nil {
                    
                    //Parsing
                    //let info = retrievedData!["Info"] as! NSDictionary
                    //let listExists = Int((info.valueForKey("NumOutRows") as? String)!)! > 0
                    //
                    //if listExists {
                    //    books = retrievedData!["List"] as! NSDictionary
                    //}
                }
                
                completionHandler(books: books, error: errorMessage)
            })
        } else {
            completionHandler(books: nil, error: RequestError.BadUrl)
        }
        
        
    }
    
    // get all chapters for a book
    static func getChapters(forBookId id:String, completionHandler: (chapters:NSDictionary?, error:RequestError?) -> (Void)) {
        
        //get specific request
        if let request = httpGetOn("/books/\(id)/chapters") {
            //get data
            getDataFromRequest(request, callback: {retrievedData, errorMessage -> Void in
                
                var chapters:NSDictionary? = nil
                
                //if no error, bring the data in needed shape
                if errorMessage == nil {
                    
                    //Parsing//let info = retrievedData!["Info"] as! NSDictionary
                    //let listExists = Int((info.valueForKey("NumOutRows") as? String)!)! > 0
                    //
                    //if listExists {
                    //    books = retrievedData!["List"] as! NSDictionary
                    //}
                }
                
                completionHandler(chapters: chapters, error: errorMessage)
            })
        } else {
            completionHandler(chapters: nil, error: RequestError.BadUrl)
        }
    }
    
    // get media for an id
    static func getMedia(forMediaId id:String, changedSince:String = "", completionHandler: (media:NSDictionary?, error:RequestError?) -> (Void)) {
        
        //get specific request
        if let request = httpGetOn("/media/\(id)") {
            //get data
            getDataFromRequest(request, callback: {retrievedData, errorMessage -> Void in
                
                var media:NSDictionary? = nil
                
                //if no error, bring the data in needed shape
                if errorMessage == nil {
                    
                    //Parsing//let info = retrievedData!["Info"] as! NSDictionary
                    //let listExists = Int((info.valueForKey("NumOutRows") as? String)!)! > 0
                    //
                    //if listExists {
                    //    books = retrievedData!["List"] as! NSDictionary
                    //}
                }
                
                completionHandler(media: media, error: errorMessage)
            })
        } else {
            completionHandler(media: nil, error: RequestError.BadUrl)
        }
    }

    
    // helper for HTTP GET requests
    private static func httpGetOn(path:String, params:String = "") -> NSMutableURLRequest? {
        
        let friendlyUrl = uri + path + params + ".json"
        
        if let requestUrl = NSURL(string: friendlyUrl) {
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: requestUrl)
            request.HTTPMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            
            return request
        } else {
            return nil
        }
    }
    
    //TODO: save Newsletter from user on remote server
//    static func postNewsletter(withData data:[String: AnyObject], completionHandler: (error:RequestError?) -> (Void)) {
//        //get specific request
//        let url = NSURL(string: getUrlTasksBase() + "ABCDEFG#@#@#@#@#@#@##@#@#@#@#@#@##@#@#@#@#@#@##@#@#@#@#@#@##")!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bearer " + getToken()!, forHTTPHeaderField: "Authorization")
//        
//        do {
//            //creat data from passed dict for saving task
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
//            request.HTTPBody = jsonData
//            
//            //send data
//            getDataFromRequest(request, callback: {retrievedData, errorMessage -> Void in
//                completionHandler(error: errorMessage)
//            })
//            
//        } catch let error as NSError {
//            print(error)
//            completionHandler(error: RequestError.InvalidData)
//        }
//    }
    
    // genericly retrieve data depending on the request (for token, patients and tasks)
    private static func getDataFromRequest(request: NSMutableURLRequest, callback: (retrievedData:NSDictionary?, errorMessage:RequestError?) -> (Void)) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var retrievedData: NSDictionary? = nil
            var errorMsg: RequestError? = nil
            
            //try to get data
            do {
                if data != nil {
                    retrievedData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as? NSDictionary
                    
                    if retrievedData == nil {
                        errorMsg = RequestError.NoData
                    }
                } else {
                    errorMsg = RequestError.NoInternet
                }
                
            } catch {
                errorMsg = RequestError.InvalidData
            }
            
            //errors depending on status codes
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                if statusCode == 401 {
                    errorMsg = RequestError.Error401
                } else if statusCode == 404 {
                    errorMsg = RequestError.Error404
                } else if statusCode == 500 {
                    errorMsg = RequestError.Error500
                }
            } else {
                errorMsg = RequestError.NoInternet
            }
            
            callback(retrievedData: retrievedData, errorMessage: errorMsg)
        })
        
        task.resume()
    }
}
