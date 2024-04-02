//
//  StockListViewController.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 27.03.2024.
//

import UIKit

class StockListViewController: UIViewController {

    private var viewModel: StockListViewModelProtocol! {
        didSet {
            viewModel.updateStocks {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private let tableView = UITableView()
    private let gradientView = GradientView()
    private var activityIndicator = UIActivityIndicatorView()
    private var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StockListViewModel()
        activityIndicator = showSpinner(in: view)
        refreshControl = setRefreshControl()
        tableViewSetup()
        setupNavigationBar()
        constraints()
    }
    
    @objc private func addButtonPressed(_ sender: Any) {
        showAddAlert(with: "ADD STOCK", and: "Write stock's ticker")
    }
    
    @objc private func editButtonPressed(_ sender: Any) {
        editStocks()
    }
    
    //MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = "Stock Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                           target: self,
                                                           action: #selector(editButtonPressed))
        
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    

    private func tableViewSetup() {
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "stockCell")
        
        if viewModel.tickers.isEmpty {
            activityIndicator.stopAnimating()
        }
        
        tableView.allowsFocusDuringEditing = true
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 94
        
        
    }
    
    
    private func constraints() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gradientView)
        gradientView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: Add spinner, Alert
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor)
        ])
        
        return activityIndicator
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Repeating ticker", message: "This ticker is already contained in your list", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(closeAction)
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }
    
    private func showAddAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "ADD", style: .default) { [unowned self] _ in
            activityIndicator.startAnimating()
            guard let ticker = (alert.textFields?.first?.text?.uppercased()) else { return }
            
            if checkRepeatingTicker(ticker) {
                return
            }
            addStockToTableView(ticker: ticker)
        }
        
        alert.addAction(closeAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
    private func addStockToTableView(ticker: String) {
        viewModel.addStock(ticker: ticker) { [unowned self] error in
            if error == nil {
                showAddAlert(with: "Invalid ticker", and: "Please try again")
                activityIndicator.stopAnimating()
            } else {
                let indexPath = IndexPath(row: viewModel.stocks.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .top)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func checkRepeatingTicker(_ ticker: String) -> Bool {
        if viewModel.tickers.contains(ticker) {
            showErrorAlert()
            return true
        }
        return false
    }
    
    //MARK: Set RefreshControl
    
    private func setRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.updateStocks() {
            self.tableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    //MARK: Editing stocks
    
    private func editStocks() {
        tableView.isEditing = tableView.isEditing ? false : true
    }
}

// MARK: - Table view data source & delegate
extension StockListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stocks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        cell.changeInPercentage.textColor = cell.viewModel.isChangeInPercentageSmallerZero ? .systemRed : .systemGreen
        cell.layer.cornerRadius = 20
        cell.cellView.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.14)
        cell.cellView.layer.cornerRadius = 20
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteStock(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}

