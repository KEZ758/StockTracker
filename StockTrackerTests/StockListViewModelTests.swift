//
//  StockListViewModelTests.swift
//  StockListViewModelTests
//
//  Created by Ерхан on 02.04.2024.
//

import XCTest
@testable import FinanceStockTracker

final class StockListViewModelTests: XCTestCase {
    
    var sut: StockListViewModel!

    override func setUp() {
        super.setUp()
        sut = StockListViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAddStock() {
        var stocks: [Stock] = []
        let ticker: String = "AMD"
        sut.addStock(ticker: ticker) { stock in
            guard let stock = stock else { return }
            stocks.append(stock)
        }
        
        XCTAssert(stocks[0].symbol == ticker, "stock not empty")
    }

    func testPerformanceExample() {
        measure {
            
        }
    }

}
