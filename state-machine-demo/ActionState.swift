//
//  ActionState.swift
//  state-machine-demo
//
//  Created by Piotr Żużel on 11/09/2018.
//  Copyright © 2018 Piotr Żużel. All rights reserved.
//

import Foundation
import RxCocoa

enum ActionState {
    case idle
    case processing
    case success
    case failure(Error)
    
    var isIdle: Bool {
        if case .idle = self {
            return true
        }
        
        return false
    }
    
    var isProcessing: Bool {
        if case .processing = self {
            return true
        }
        return false
    }
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var isFailure: Bool {
        if case .failure = self {
            return true
        }
        return false
    }
}

// Convenience extension for BehaviorRelay values updates
extension BehaviorRelay where Element == ActionState {
    func setIdle() {
        accept(.idle)
    }
    
    func setProcessing() {
        accept(.processing)
    }
    
    func setSuccess() {
        accept(.success)
        setIdle()
    }
    
    func setFailure(_ error: Error) {
        accept(.failure(error))
        setIdle()
    }
}

