//
//  ViewController.swift
//  rainierrivera
//
//  Created by John Rivera on 15/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

  // MARK: Outlets

  @IBOutlet private weak var conversionLabel: UILabel!
  @IBOutlet private weak var amountTextField: UITextField!
  @IBOutlet private weak var sourceCurrencyTextField: UITextField!
  @IBOutlet private weak var destinationCurrencyTextField: UITextField!
  @IBOutlet private weak var conversionButton: UIButton!
  @IBOutlet private weak var resultLabel: UILabel!

  // MARK: Private properties
  
  private var viewModel: CurrencyViewModel!

  private var selectedSourceCurrency: CurrencyType!
  private var selectedDestionationCurrency: CurrencyType!

  private var sourceCurrencyPickerView: UIPickerView!
  private var destinationCurrencyPickerView: UIPickerView!

  private var isEnabledConversionButton: Bool {
    return selectedDestionationCurrency != nil && selectedSourceCurrency != nil && amountTextField.text?.isEmpty == false
  }

  // MARK: Overrides

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    setupViewModel()
    setupViews()
  }

  // MARK: Private Methods

  private func setupViewModel() {
    viewModel = CurrencyViewModel()
    viewModel.delegate = self
  }

  private func setupViews() {
    sourceCurrencyPickerView = UIPickerView()
    sourceCurrencyPickerView.delegate = self
    sourceCurrencyPickerView.dataSource = self

    destinationCurrencyPickerView = UIPickerView()
    destinationCurrencyPickerView.delegate = self
    destinationCurrencyPickerView.dataSource = self
    sourceCurrencyTextField.inputView = sourceCurrencyPickerView
    destinationCurrencyTextField.inputView = destinationCurrencyPickerView

    amountTextField.delegate = self
    sourceCurrencyTextField.delegate = self
    destinationCurrencyTextField.delegate = self

    conversionLabel.text = viewModel.freeConversionText
    updateConversionButtonState(isEnabled: isEnabledConversionButton)
  }

  private func updateConversionButtonState(isEnabled: Bool) {
    conversionButton.alpha = isEnabled ? 1 : 0.5
    conversionButton.isEnabled = isEnabled
  }


  // MARK: Actions

  @IBAction private func convertCurrency(_ sender: AnyObject) {
    let amountString = amountTextField.text ?? "0.00"
    let amount = Double(amountString) ?? 0.00
    viewModel.conversion = Conversion(amount: amount,
                                      sourceCurrency: selectedSourceCurrency,
                                      destinationCurrency: selectedDestionationCurrency)
    viewModel.updateCurrency(conversion: viewModel.conversion)
  }
}

// MARK: Currency Delegate

extension CurrencyViewController: CurrencyViewModelDelegate {
  func currencyViewModelDelegateDidConvertCurrency(_ viewModel: CurrencyViewModel, conversion: Conversion) {
    resultLabel.text = viewModel.resultText
    conversionLabel.text = viewModel.freeConversionText
  }
}

// MARK: Pickerview Delegate

extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return CurrencyType.list[row].description
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return CurrencyType.list.count // none is not included on the list
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == sourceCurrencyPickerView {
      sourceCurrencyTextField.text = CurrencyType.list[row].description
      selectedSourceCurrency = CurrencyType.list[row]
    } else if pickerView == destinationCurrencyPickerView {
      destinationCurrencyTextField.text = CurrencyType.list[row].description
      selectedDestionationCurrency = CurrencyType.list[row]
    }
    updateConversionButtonState(isEnabled: isEnabledConversionButton)
  }
}

// MARK: Textfield Delegate

extension CurrencyViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == sourceCurrencyTextField && selectedSourceCurrency == nil {
      pickerView(sourceCurrencyPickerView, didSelectRow: 0, inComponent: 1)
    } else if textField == destinationCurrencyTextField && selectedDestionationCurrency == nil {
      pickerView(destinationCurrencyPickerView, didSelectRow: 0, inComponent: 1)
    }
    updateConversionButtonState(isEnabled: isEnabledConversionButton)
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    updateConversionButtonState(isEnabled: isEnabledConversionButton)
  }
}
