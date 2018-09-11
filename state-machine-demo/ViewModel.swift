//
//  ViewModel.swift
//  state-machine-demo
//
//  Created by Piotr Żużel on 11/09/2018.
//  Copyright © 2018 Piotr Żużel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// Domain errors
extension ViewModel {
    enum Error: LocalizedError {
        case someError
        
        var errorDescription: String? {
            switch self {
            case .someError:
                return "Whoops! Some error occured"
            }
        }
    }
}

final class ViewModel {
    private let failingRelay = BehaviorRelay(value: ActionState.idle)
    private let succeedingRelay = BehaviorRelay(value: ActionState.idle)
    
    var failingAction: Observable<ActionState> {
        return failingRelay.asObservable()
    }
    var succeedingAction: Observable<ActionState> {
        return succeedingRelay.asObservable()
    }
    
    // MARK: Actions
    func triggerFailingAction() {
        failingRelay.setProcessing()
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.failingRelay.setFailure(Error.someError)
        }
    }
    
    func triggerSucceedingAction() {
        succeedingRelay.setProcessing()
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.succeedingRelay.setSuccess()
        }
    }
}
