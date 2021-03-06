//
//  ExchangeServices.swift
//  Blockchain
//
//  Created by Alex McGregor on 2/19/19.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import Foundation
import PlatformKit
import StellarKit
import ToolKit

protocol ExchangeDependencies {
    var service: ExchangeHistoryAPI { get }
    var markets: ExchangeMarketsAPI { get }
    var conversions: ExchangeConversionAPI { get }
    var inputs: ExchangeInputsAPI { get }
    var tradeExecution: TradeExecutionAPI { get }
    var assetAccountRepository: AssetAccountRepositoryAPI { get }
    var tradeLimits: TradeLimitsAPI { get }
    var analyticsRecorder: AnalyticsEventRecording { get }
    var fiatCurrencySettingsService: FiatCurrencySettingsServiceAPI { get }
}

struct ExchangeServices: ExchangeDependencies {
    let service: ExchangeHistoryAPI
    let markets: ExchangeMarketsAPI
    var conversions: ExchangeConversionAPI
    let inputs: ExchangeInputsAPI
    let tradeExecution: TradeExecutionAPI
    let assetAccountRepository: AssetAccountRepositoryAPI
    let tradeLimits: TradeLimitsAPI
    let analyticsRecorder: AnalyticsEventRecording
    let fiatCurrencySettingsService: FiatCurrencySettingsServiceAPI

    init(tradeLimits: TradeLimitsAPI = resolve(), analyticsRecorder: AnalyticsEventRecording = resolve()) {
        service = ExchangeService()
        markets = MarketsService()
        conversions = ExchangeConversionService()
        inputs = ExchangeInputsService()
        assetAccountRepository = AssetAccountRepository.shared
        tradeExecution = TradeExecutionService(
            wallet: WalletManager.shared.wallet,
            dependencies: TradeExecutionService.Dependencies()
        )
        fiatCurrencySettingsService = resolve()
        self.tradeLimits = tradeLimits
        self.analyticsRecorder = analyticsRecorder
    }
}
