//
//  NetworkManager.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 27.03.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func fetchStock(with ticker: String, completion: @escaping(Stock) -> Void) {
        
        let url = "https://financialmodelingprep.com/api/v3/quote/\(ticker)?apikey=a15af8fcd7e5332f5022f0ccca771b00"
        
        guard let stockUrl = URL(string: url) else {
            print(NetworkError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: stockUrl) { data, _, error in
            guard let data = data else {
                print(NetworkError.noData)
                return
            }
            
            do {
                let stocks = try JSONDecoder().decode([Stock].self, from: data)
                DispatchQueue.main.async {
                    if !stocks.isEmpty {
                        let stock = Stock(symbol: stocks[0].symbol, price: stocks[0].price, name: stocks[0].name, changesPercentage: stocks[0].changesPercentage)
                        completion(stock)
                    } else {
                        print(error ?? "error")
                    }
                }
            }catch {
                print(NetworkError.decodingError)
                return
            }
        }.resume()
    }
    
    
    
}
