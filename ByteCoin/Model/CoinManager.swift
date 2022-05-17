//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateBitcoinPrice(_ coinManager: CoinManager, amount: Double, rate: Double, currency: String)
    func didFailWithError(_ error: Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "80382FB0-DFD4-4644-810F-34B26A63177A"
    
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var amount: Double = 4.72323
    var currency = "EUR"
    
    func getCoinPrice(){
        let url = "\(baseURL)/\(self.currency)?apikey=\(apiKey)"
        performRequest(with: url, for: self.currency)
    }
    
    func performRequest(with urlString: String, for currency: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {d, r, e in
                if e != nil {
                    print("error")
                    return
                }
                if let safeData = d {
                    if let bitcoinPrice = parseJSON(safeData) {
                        delegate?.didUpdateBitcoinPrice(self, amount: self.amount, rate: bitcoinPrice.rate, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
