//
//  PaxToken.swift
//  ERC20Kit
//
//  Created by Jack on 15/04/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import BigInt
import EthereumKit
import PlatformKit

public struct PaxToken: ERC20Token {
    public static let nonCustodialSendSupport: Bool = true
    public static let assetType: CryptoCurrency = .pax
    public static let contractAddress: EthereumContractAddress = "0x8E870D67F660D95d5be530380D0eC0bd388289E1"

    //swiftlint:disable:next force_try
    public static let smallestSpendableValue: ERC20TokenValue<Self> = try! ERC20TokenValue<Self>(
        crypto: CryptoValue.create(major: "0.01", currency: assetType)!
    )
}
