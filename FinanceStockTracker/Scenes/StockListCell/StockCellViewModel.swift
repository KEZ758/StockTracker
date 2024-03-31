//
//  StockCellViewModel.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 31.03.2024.
//

import Foundation


protocol StockCellViewModelProtocol {
    
    var ticker: String { get }
    var name: String { get }
    var price: String { get }
    var changeInPercentage: String { get }
    var isChangeInPercentageSmallerZero: Bool { get }
    
    init(stock: Stock)
    
}

class StockCellViewModel: StockCellViewModelProtocol {
    
    var isChangeInPercentageSmallerZero: Bool {
        stock.changesPercentage < 0 ? true : false
    }
    
    var ticker: String {
        stock.symbol
    }
    
    var name: String {
        stock.name
    }
    
    var price: String {
        String(format: "%.2f", stock.price )
    }
    
    var changeInPercentage: String {
        String(format: "%.2f", stock.changesPercentage )
    }
    
    private let stock: Stock
    
    required init(stock: Stock) {
        self.stock = stock
    }
    
}

