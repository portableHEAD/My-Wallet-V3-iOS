//
//  ExchangeError.swift
//  Blockchain
//
//  Created by AlexM on 3/21/19.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation
import PlatformKit

enum ExchangeError: Error, Equatable {
    case belowTradingLimit(FiatValue?, AssetType)
    case aboveTradingLimit(FiatValue?, AssetType)
    case aboveTierLimit(FiatValue, AssetType)
    case aboveMaxVolume(CryptoValue)
    case insufficientFunds(CryptoValue)
    case noVolumeProvided
    
    /// Should only happen when `"NO_UNSPENT_OUTPUTS"` is returned
    /// from the JS layer.
    case insufficientFundsForFees(AssetType)
    case waitingOnEthereumPayment
    case `default`(String?)
}

extension ExchangeError {
    static func ==(lhs: ExchangeError, rhs: ExchangeError) -> Bool {
        switch (lhs, rhs) {
        case (.belowTradingLimit(let leftFiat, let leftAsset), .belowTradingLimit(let rightFight, let rightAsset)):
            return leftFiat == rightFight &&
            leftAsset == rightAsset
        case (.aboveTradingLimit(let leftFiat, let leftAsset), .aboveTradingLimit(let rightFight, let rightAsset)):
            return leftFiat == rightFight &&
                leftAsset == rightAsset
        case (.aboveTierLimit(let leftFiat, let leftAsset), .aboveTierLimit(let rightFight, let rightAsset)):
            return leftFiat == rightFight &&
                leftAsset == rightAsset
        case (.aboveMaxVolume(let leftCrypto), .aboveMaxVolume(let rightCrypto)):
            return leftCrypto == rightCrypto
        case (.insufficientFunds(let leftCrypto), .insufficientFunds(let rightCrypto)):
            return leftCrypto == rightCrypto
        case (.insufficientFundsForFees(let leftAsset), .insufficientFundsForFees(let rightAsset)):
            return leftAsset == rightAsset
        case (.waitingOnEthereumPayment, .waitingOnEthereumPayment):
            return true
        case (.default(let left), .default(let right)):
            return left == right
        case (.noVolumeProvided, .noVolumeProvided):
            return true
        default:
            return false
        }
    }
}

extension ExchangeError {
    var title: String {
        switch self {
        case .belowTradingLimit,
             .noVolumeProvided:
            return LocalizationConstants.Exchange.belowTradingLimit
        case .aboveTradingLimit:
            return LocalizationConstants.Exchange.aboveTradingLimit
        case .aboveTierLimit:
            return LocalizationConstants.Swap.upgradeNow
        case .aboveMaxVolume(let cryptoValue):
            guard cryptoValue.currencyType == .stellar else {
                assertionFailure("This should only happen with XLM at this time.")
                return ""
            }
            return LocalizationConstants.Stellar.notEnoughXLM
        case .insufficientFunds(let cryptoValue):
            let symbol = cryptoValue.symbol
            let notEnouch = LocalizationConstants.Exchange.notEnough + " " + symbol + "."
            return notEnouch
        case .insufficientFundsForFees(let cryptoValue):
            return LocalizationConstants.Errors.notEnoughXForFees + cryptoValue.symbol
        case .waitingOnEthereumPayment:
            return LocalizationConstants.SendEther.waitingForPaymentToFinishMessage
        case .default:
            return LocalizationConstants.Errors.genericError
        }
    }
    
    var description: String? {
        switch self {
        case .belowTradingLimit(let value, _):
            let yourMin = LocalizationConstants.Exchange.yourMin
            let result = yourMin + " " + (value?.toDisplayString(includeSymbol: true, locale: .current) ?? "")
            return result
        case .aboveTradingLimit(let value, _):
            let yourMax = LocalizationConstants.Exchange.yourMax
            let result = yourMax + " " + (value?.toDisplayString(includeSymbol: true, locale: .current) ?? "")
            return result
        case .aboveTierLimit(let fiatValue, _):
            let message = LocalizationConstants.Swap.tierlimitErrorMessage + fiatValue.toDisplayString(includeSymbol: true, locale: .current)
            return message
        case .aboveMaxVolume(let cryptoValue):
            let description = LocalizationConstants.Exchange.yourSpendableBalance
            let result = description + " " + cryptoValue.toDisplayString(includeSymbol: true, locale: .current)
            return result
        case .insufficientFunds(let cryptoValue):
            let yourBalance = LocalizationConstants.Exchange.yourBalance + " " + cryptoValue.toDisplayString(includeSymbol: true, locale: .current)
            return yourBalance + "."
        case .insufficientFundsForFees(let assetType):
            return LocalizationConstants.Errors.notEnoughXForFees + assetType.symbol
        case .waitingOnEthereumPayment:
            return nil
        case .noVolumeProvided:
            return nil
        case .default(let value):
            return value
        }
    }
    
    var image: UIImage {
        switch self {
        case .belowTradingLimit(_, let asset):
            return asset.errorImage
        case .aboveTierLimit(_, let asset):
            return asset.errorImage
        case .aboveTradingLimit(_, let asset):
            return asset.errorImage
        case .insufficientFundsForFees(let asset):
            return asset.errorImage
        case .waitingOnEthereumPayment:
            return #imageLiteral(resourceName: "eth_bad.pdf")
        case .aboveMaxVolume(let cryptoValue):
            return cryptoValue.currencyType.toAssetType.errorImage
        case .insufficientFunds(let cryptoValue):
            return cryptoValue.currencyType.toAssetType.errorImage
        case .default,
             .noVolumeProvided:
            return #imageLiteral(resourceName: "error-triangle.pdf")
        }
    }
    
    var url: URL? {
        switch self {
        case .belowTradingLimit,
             .aboveTierLimit,
             .aboveTradingLimit,
             .aboveMaxVolume:
            guard let base = URL(string: "https://support.blockchain.com") else { return nil }
            return URL.endpoint(
                base,
                pathComponents: ["hc", "en-us", "articles", "360018353031-What-are-the-minimum-and-maximum-amounts-I-can-Swap-"],
                queryParameters: nil
            )
        default:
            return nil
        }
    }
}

extension CryptoCurrency {
    var toAssetType: AssetType {
        switch self {
        case .bitcoin:
            return .bitcoin
        case .bitcoinCash:
            return .bitcoinCash
        case .ethereum:
            return .ethereum
        case .stellar:
            return .stellar
        }
    }
}

fileprivate extension AssetType {
    var errorImage: UIImage {
        switch self {
        case .bitcoin:
            return #imageLiteral(resourceName: "btc_bad.pdf")
        case .bitcoinCash:
            return #imageLiteral(resourceName: "bch_bad.pdf")
        case .ethereum:
            return #imageLiteral(resourceName: "eth_bad.pdf")
        case .stellar:
            return #imageLiteral(resourceName: "xlm_bad.pdf")
        }
    }
}