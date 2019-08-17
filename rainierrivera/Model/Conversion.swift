//
//  Account.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation

class Conversion {
  var amount: Double
  var sourceCurrency: CurrencyType
  var destinationCurrency: CurrencyType

  var newAmount: String = ""

  init(amount: Double, sourceCurrency: CurrencyType, destinationCurrency: CurrencyType) {
    self.amount = amount
    self.sourceCurrency = sourceCurrency
    self.destinationCurrency = destinationCurrency
  }
}
