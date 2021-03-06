//
//  UserCreationClient.swift
//  PlatformKit
//
//  Created by Daniel Huri on 13/05/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import NetworkKit
import RxSwift

public protocol UserCreationClientAPI: class {
    func createUser(for jwtToken: String) -> Single<NabuOfflineTokenResponse>
}

final class UserCreationClient: UserCreationClientAPI {
    
    // MARK: - Types

    private enum Parameter: String {
        case jwt
    }
    
    private enum Path {
        static let users = [ "users" ]
    }
    
    // MARK: - Properties
    
    private let requestBuilder: RequestBuilder
    private let communicator: NetworkCommunicatorAPI

    // MARK: - Setup
    
    init(communicator: NetworkCommunicatorAPI = resolve(tag: DIKitContext.retail),
         requestBuilder: RequestBuilder = resolve(tag: DIKitContext.retail)) {
        self.communicator = communicator
        self.requestBuilder = requestBuilder
    }
        
    func createUser(for jwtToken: String) -> Single<NabuOfflineTokenResponse> {
        struct Payload: Encodable {
            let jwt: String
        }
        
        let payload = Payload(jwt: jwtToken)
        let request = requestBuilder.post(
            path: Path.users,
            body: try? payload.encode()
        )!
        return communicator.perform(request: request)
    }
}
