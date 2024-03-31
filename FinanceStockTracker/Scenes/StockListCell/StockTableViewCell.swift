//
//  StockTableViewCell.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 30.03.2024.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    var cellView = UIView()
    private var ticker = UILabel(textColor: .white, font: UIFont.systemFont(ofSize: 23))
    private var name = UILabel(textColor: .white, font: UIFont.systemFont(ofSize: 14))
    private var price = UILabel(textColor: .white, font: UIFont.systemFont(ofSize: 22))
    var changeInPercentage = UILabel(textColor: .white, font: UIFont.systemFont(ofSize: 13))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func constraints() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        let tickerAndNameStack = UIStackView(arrangedSubviews: [ticker, name], axis: .vertical, spacing: 0.0)
        let priceAndChangeStack = UIStackView(arrangedSubviews: [price, changeInPercentage], axis: .vertical, spacing: 0.0)
        
        tickerAndNameStack.translatesAutoresizingMaskIntoConstraints = false
        priceAndChangeStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellView)
        cellView.addSubview(tickerAndNameStack)
        cellView.addSubview(priceAndChangeStack)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cellView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tickerAndNameStack.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16.5),
            tickerAndNameStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 18),
            tickerAndNameStack.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceAndChangeStack.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 17),
            priceAndChangeStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -18),
            priceAndChangeStack.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
    
    var viewModel: StockCellViewModelProtocol! {
        didSet {
            ticker.text = viewModel.ticker
            name.text = viewModel.name
            price.text = "$\(viewModel.price)"
            changeInPercentage.text = "\(viewModel.changeInPercentage)%"
        }
    }
}
