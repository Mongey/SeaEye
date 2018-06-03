//
//  HTTPRequest.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

func HTTPRequest <T: Decodable>(_ request: URLRequest, of:T.Type, completion:((Result<T>) -> Void)?) {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in  DispatchQueue.main.async {
        guard responseError == nil else {
            completion!(.failure(responseError!))
            return
        }
        
        guard let jsonData = responseData else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
            completion!(.failure(error))
            return
        }
        
        do {
            let data = try CircleCIDecoder().decode(T.self, from: jsonData)
            completion!(.success(data))
        } catch {
            completion!(.failure(error))
        }
        }
    }
    task.resume()
}
