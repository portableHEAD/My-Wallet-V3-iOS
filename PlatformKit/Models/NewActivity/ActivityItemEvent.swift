//
//  ActivityItemEvent.swift
//  PlatformKit
//
//  Created by Alex McGregor on 4/24/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

public enum ActivityItemEvent: Tokenized {
    case swap(SwapActivityItemEvent)
    // Send/Receive
    case transactional(TransactionalActivityItemEvent)
    // TODO: Buy/Sell
    
    /// The `Status` of an activity item.
    public enum EventStatus {
        
        public struct Confirmations {
            /// How many confirmations have taken place
            public let current: Int
            /// The total number of confirmations required
            public let total: Int
        }
        
        /// The event is pending confirmation
        case pending(confirmations: Confirmations)
        /// The event has completed
        case complete
        // TODO: Products such as Swap, Buy, Sell
        // may have their own status'
        case product(SwapActivityItemEvent.EventStatus)
    }
    
    // TODO: Each model may handle pagination differently
    // e.g. some models may be paged by means of a date
    // and others a unique ID (Stellar).
    public var token: String {
        switch self {
        case .swap(let event):
            return event.identifier
        case .transactional(let event):
            return event.identifier
        }
    }
    
    public var creationDate: Date {
        switch self {
        case .swap(let swap):
            return swap.date
        case .transactional(let transaction):
            return transaction.creationDate
        }
    }
}

extension ActivityItemEvent {
    
    public var amount: CryptoValue {
        switch self {
        case .swap(let event):
            return event.amounts.deposit
        case .transactional(let event):
            return event.amount
        }
    }
    
    public var identifier: String {
        switch self {
        case .swap(let event):
            return event.identifier
        case .transactional(let event):
            return event.identifier
        }
    }
    
    public var status: EventStatus {
        switch self {
        case .swap(let event):
            return .product(event.status)
        case .transactional(let event):
            switch event.status {
            case .complete:
                return .complete
            case .pending(confirmations: let confirmations):
                return .pending(confirmations: .init(
                    current: confirmations.current,
                    total: confirmations.total
                    )
                )
            }
        }
    }
}

extension ActivityItemEvent: Equatable {
    public static func == (lhs: ActivityItemEvent, rhs: ActivityItemEvent) -> Bool {
        switch (lhs, rhs) {
        case (.swap(let left), .swap(let right)):
            return left == right
        case (.transactional(let left), .transactional(let right)):
            return left == right
        default:
            return false
        }
    }
}