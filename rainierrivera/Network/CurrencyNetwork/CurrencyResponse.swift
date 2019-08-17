//
//  CurrencyResponse.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation

struct CurrencyResponse: Codable {
  var amount, currency: String

  private var currenctType: CurrencyType {
    return CurrencyType(rawValue: currency) ?? .none
  }

}

enum CurrencyType: String, CaseIterable {
  case euro = "EUR"
  case yen = "JPY"
  case dollar = "USD"
  case none

  var description: String {
    return rawValue
  }

  static var list: [CurrencyType] {
    return [.euro, .yen, .dollar]
  }
}
