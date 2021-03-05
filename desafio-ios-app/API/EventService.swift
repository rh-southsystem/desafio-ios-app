//
//  EventService.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Alamofire

protocol EventServiceProtocol {
    func fetch(params: Token, completionHandler: @escaping CompletionHandler<[Event]>)
}

class EventService: BaseService, EventServiceProtocol {
    func fetch(params: Token, completionHandler: @escaping CompletionHandler<[Event]>) {
        performRequest(EventRouter.fetch(params), completionHandler)
    }
}
