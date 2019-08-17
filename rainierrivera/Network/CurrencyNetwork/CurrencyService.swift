//
//  CurrencyService.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation

protocol CurrencyAPI {
  func UpdateCurrency(amount: String,
                      currency: CurrencyType,
                      toCurrency: CurrencyType,
                      completion: @escaping (APIResponse<CurrencyResponse>) -> Void)
}

struct CurrencyService: CurrencyAPI {

  init(networkManager: NetworkManager = .init()) {
    self.networkManager = networkManager
  }

  private let networkManager: NetworkManager

  func UpdateCurrency(amount: String, currency: CurrencyType, toCurrency: CurrencyType, completion: @escaping (APIResponse<CurrencyResponse>) -> Void) {
    CurrencyRequest(amount: amount, currency: currency, toCurrency: toCurrency, networkManager: networkManager)
      .request(completion: completion)
  }
}
