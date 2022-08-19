//
//  SearchStockViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import UIKit

class SearchStockViewController: UIViewController {
    
    //var listOfCompanyDetail = [CompanyDetail]()
    
    // Search controller
    lazy var searchController = UISearchController(searchResultsController: addStockTableVC)
    lazy var addStockTableVC = self.storyboard?.instantiateViewController(withIdentifier: "addStockTableVC") as! AddStockTableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStockTableVC.delegate = self
        //searchController
        title = "Add Stock"
        searchController.searchBar.placeholder = "Search stocks"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
}

extension SearchStockViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        _ = ServiceManager.createRequest(route: .financeSearch(searchText), method: .get) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let company):
                //self?.listOfCompanyDetail = stocks
                self?.addStockTableVC.companyList = company
                print(company.description)
            }
        }
    }
}
// MARK: = Custom protocol written to get the city name from tableview after city is chosen
extension SearchStockViewController: TableStocksDelegate {
    func companySelected(data: CompanyDetail) {
        let cityName = data.name
        title = cityName
        //SearchStockViewController.
        //AddCityViewController.selectedCity = cityName
        print("City has been selected")
        
        searchController.isActive = false
    }

}



