//
//  BaseService.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Alamofire


class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class BaseService {
    let sessionManager: SessionManager = {  return Alamofire.SessionManager.default }()
    typealias HeaderResponse = [AnyHashable: Any]
    
    func performRequest<T: Codable>(_ route: URLRequestConvertible, sendGenericErrorNotification: Bool = true,
                                    _ completionHandler: @escaping (T?, ErrorResponse?, HeaderResponse?) -> Void) {
        
        sessionManager
            .request(route)
            .validate(contentType: ["application/json"])
            .response { dataResponse in
                let headers = dataResponse.response?.allHeaderFields
                guard let response = dataResponse.response else {
                    if let err = dataResponse.error as? URLError {
                        debugPrint("- Request: \(route.urlRequest?.url?.absoluteString ?? "no url")",
                                   "-- Err Code: \(err.code)", separator: "\n", terminator: "\n\n")
                        switch err.code {
                        case URLError.Code.notConnectedToInternet, URLError.Code.secureConnectionFailed:
                            completionHandler(nil, ErrorResponse.noInternetConnection(), headers)
                            return
                        default:
                            break
                        }
                    }
                    
                    completionHandler(nil, ErrorResponse.somethingWentWrong(), headers)
                    
                    return
                }
                
                debugPrint("- Request: \(route.urlRequest?.url?.absoluteString ?? "no url")",
                           "-- Status Code: \(response.statusCode)", separator: "\n", terminator: "\n\n")
                
                switch response.statusCode {
                case 200..<300:
                    
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: dataResponse.data!)
                        completionHandler(decoded, nil, headers)
                    } catch let parseError {
                        print(parseError)
                        completionHandler(nil, nil, headers)
                    }
                default:
                    if let err = dataResponse.error as? URLError {
                        debugPrint("- Request: \(route.urlRequest?.url?.absoluteString ?? "no url")",
                                   "-- Err Code: \(err.code)", separator: "\n", terminator: "\n\n")
                        switch err.code {
                        case URLError.Code.notConnectedToInternet, URLError.Code.secureConnectionFailed:
                            completionHandler(nil, ErrorResponse.noInternetConnection(), headers)
                            return
                        default:
                            break
                        }
                    }
                    print(dataResponse.error.debugDescription)
                    
                    completionHandler(nil, ErrorResponse.somethingWentWrong(), headers)
                }
            }
    }
}
