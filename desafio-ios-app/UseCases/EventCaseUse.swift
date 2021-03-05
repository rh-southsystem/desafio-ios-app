//
//  EventCaseUse.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Foundation

enum EventUseCaseResponse {
    case success([Event])
    case failure
}

protocol EventUseCaseProtocol {
    typealias EventResponseCompletion = (EventUseCaseResponse) -> Void
    func fetch(params: Token, completion: @escaping EventResponseCompletion)
}


class EventUseCase: EventUseCaseProtocol {
    let service: EventServiceProtocol
    
    init(service: EventServiceProtocol = EventService()) {
        self.service = service
    }
    
    func fetch(params: Token, completion: @escaping EventResponseCompletion) {
        service.fetch(params: params) {(response, errorResponse, _ ) in
            if errorResponse == nil, let events : [Event] = response {
                completion(.success(events))
            } else {
                completion(.failure)
            }
        }
    }
}




