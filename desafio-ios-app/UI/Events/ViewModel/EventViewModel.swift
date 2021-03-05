//
//  EventViewModel.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import RxSwift
import RxCocoa

enum EventStatus {
    case loading
    case success
    case genericError
}


class EventViewModel {
    let useCase: EventUseCaseProtocol
    let subjectError = PublishSubject<String>()
    let eventStatus = PublishSubject<EventStatus>()
    var listEvents = BehaviorRelay<[Event]?>(value: nil)
    
    init(useCase: EventUseCaseProtocol = EventUseCase()) {
        self.useCase = useCase
    }
    
    func fetchEvents() {
        eventStatus.onNext(.loading)
        let token = UserDefaults.standard.string(forKey: "token")
        useCase.fetch(params: Token(token: token)) {[weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let events):
                self.listEvents.accept(events.sorted{$0.id ?? 0 < $1.id ?? 0})
                self.eventStatus.onNext(.success)
            case .failure:
                self.eventStatus.onNext(.genericError)
            }
        }
    }
}

