//
//  AlamofirePBExt.swift
//  AlamofireSwiftProtobufExt
//
//  Created by appdev on 2018/3/16.
//  Copyright © 2018年 opz. All rights reserved.
//


import Foundation
import Alamofire
import SwiftProtobuf


struct AlamofirePBDataEncoding: ParameterEncoding {
    private let msg: SwiftProtobuf.Message
    
    init(msg: SwiftProtobuf.Message) {
        self.msg = msg
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try self.msg.serializedData()
        urlRequest.httpBody = data
        
        return urlRequest
    }
}

enum AlamofirePBError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case pbSerialization(error: Error)
}

extension DataRequest {
    static func pbCsmsgRespondSerializer() -> DataResponseSerializer<CSMsgRespond> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(AlamofirePBError.network(error: error!))
            }
            
            // Use Alamofire's existing data serializer to extract the data, passing the error as nil, as it has
            // already been handled.
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            
            guard case let .success(validData) = result else {
                return .failure(AlamofirePBError.dataSerialization(error: result.error! as! AFError))
            }
            //let debugStr = String(data: validData, encoding: .utf8)
            //print(debugStr)
            do {
                let rspObj = try CSMsgRespond(serializedData: validData);
                return .success(rspObj)
            } catch {
                
                return .failure(AlamofirePBError.pbSerialization(error: error) )
            }
        }
    }
    
    @discardableResult
    func responsePBCsmsg( queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CSMsgRespond>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.pbCsmsgRespondSerializer(), completionHandler: completionHandler)
    }
}
