//
//  CurrencyRequest.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation
import Alamofire

final class CurrencyRequest: ManagedRequest {

  let amount: String
  let currency: CurrencyType
  let toCurrency: CurrencyType
  init(amount: String,
       currency: CurrencyType,
       toCurrency: CurrencyType,
       networkManager: NetworkManager = .init()) {
    self.amount = amount
    self.currency = currency
    self.toCurrency = toCurrency
    super.init(withNetworkManager: networkManager)
  }

  override func requestURL() -> URLConvertible {
    return "http://api.evp.lt/currency/commercial/exchange/\(amount)-\(currency.description)/\(toCurrency.description)/latest"
  }
}


