//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var bitcoinCount: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        let defaultCurrency = coinManager.currencyArray.firstIndex(of: "EUR")!
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.selectRow(defaultCurrency, inComponent: 0, animated: true)
        bitcoinCount.delegate = self
        coinManager.delegate = self
        
        coinManager.getCoinPrice()
    }

}

//MARK: - PickerDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - pickerDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.currency = coinManager.currencyArray[row]
        coinManager.getCoinPrice()
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        bitcoinCount.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bitcoinCount.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let amount = bitcoinCount.text {
            coinManager.amount = Double(amount)! * 1000
            coinManager.getCoinPrice()
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "1"
            return false
        }
    }
}


//MARK: - coinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didFailWithError(_ error: Error) {
        print("sth went terribly wrong. im fine though. \nprinting error: \(error)")
    }
    
    func didUpdateBitcoinPrice(_ coinManager: CoinManager, amount: Double, rate: Double, currency: String) {
        DispatchQueue.main.async {
            let price = amount * rate / 1000
            self.bitcoinLabel.text = String(format: "%.2f", price)
            self.currencyLabel.text = currency
        }
        
    }
}
