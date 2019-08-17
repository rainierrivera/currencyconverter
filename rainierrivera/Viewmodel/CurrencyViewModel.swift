//
//  CurrencyViewModel.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation

protocol CurrencyViewModelDelegate: class {
  func currencyViewModelDelegateDidConvertCurrency(_ viewModel: CurrencyViewModel, conversion: Conversion)
}

class CurrencyViewModel {

  init(currencyService: CurrencyService = .init()) {
    self.currencyService = currencyService
  }

  // MARK: Private properties

  private struct Constant {
    // above this is free of charge
    static let euroSale = 200.0
    static let dollarSale = 200.0
  }

  private var commissionFeeText: String {
    return String(format: "%.2f", conversion.amount * 0.007)
  }

  private var commissionFee: Double {
    return 0.007
  }

  private var amountToConvert: Double {
    if freeConversionValue <= 0 {
      if isFreeOfCharge { return conversion.amount }
      return conversion.amount - (conversion.amount * commissionFee)
    }
    return conversion.amount
  }

  private var isFreeOfCharge: Bool {
    if conversion.sourceCurrency == .euro {
      return conversion.amount >= Constant.euroSale
    } else if conversion.sourceCurrency == .dollar {
      return conversion.amount >= Constant.dollarSale
    }
    return false
  }

  private var canConvertAmount: Bool {
    if freeConversionValue > 0 && conversion.amount > 0  { return true }
    return amountToConvert >= 0
  }

  // MARK: Public properties

  weak var delegate: CurrencyViewModelDelegate?
  var freeConversionValue = 5
  let currencyService: CurrencyService
  var conversion: Conversion!

  var freeConversionText: String {
    if freeConversionValue < 0 {
      return "Free conversion: 0"
    }
    return "Free conversion: \(freeConversionValue)"
  }

  var resultText: String {
    let defaultText = "You have converted \(String(conversion.amount)) \(conversion.sourceCurrency.description) to \(conversion.newAmount) \(conversion.destinationCurrency.description)."

    if isFreeOfCharge {
      return defaultText
    }

    if freeConversionValue < 0 {
      return "You have converted \(String(amountToConvert)) \(conversion.sourceCurrency.description) to \(conversion.newAmount) \(conversion.destinationCurrency.description). Commission Fee - \(commissionFeeText) \(conversion.sourceCurrency.description)."
    }
    return defaultText
  }

  // MARK: Methods

  func updateCurrency(conversion: Conversion) {
    if !canConvertAmount { return }
    let amountString = String(amountToConvert)
    currencyService.UpdateCurrency(amount: amountString,
                                   currency: conversion.sourceCurrency,
                                   toCurrency: conversion.destinationCurrency) { [weak self] response in
                                    guard let self = self else { return }

                                    switch response {
                                    case let .success(result):
                                      self.freeConversionValue -= 1
                                      self.conversion.newAmount = result.amount
                                      print("‼️ \(self.amountToConvert)")
                                      print("🔥 \(result.amount)")
                                      self.delegate?.currencyViewModelDelegateDidConvertCurrency(self, conversion: self.conversion)
                                    default: break // we do not catch error
                                    }

    }
  }
}


