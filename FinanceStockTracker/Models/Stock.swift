//
//  Stock.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 27.03.2024.
//

import Foundation


struct Stock: Decodable {
    
    let symbol: String
    let price: Float
    let name: String
    let changesPercentage: Float
    
}
