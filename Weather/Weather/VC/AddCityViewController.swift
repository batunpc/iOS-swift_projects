//
//  AddCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit

class AddCityViewController: UIViewController {
    
    lazy var searchCityTable = self.storyboard?.instantiateViewController(withIdentifier: "searchCityTableID") as! SearchCityTableViewController
    lazy var searchController = UISearchController(searchResultsController: searchCityTable)
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentSearchTask: URLSessionTask?
     //var cityList : [String]? = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //Custom protocol
        searchCityTable.cityProtocol = self
        //searchController
        title = "Search city"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func addCity(name: String) {
        // Instantiating the managed object associated with the main context
        print(name)
        //let city = City(context: appDelegate)
        //city.city_name = name.components(separatedBy: ",")[0]
        //try? appDelegate.save()
    }
}

// MARK: = Search controller
extension AddCityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text {
            guard let safeUrl = URL(string: URLState.geobytes(searchText).APIString) else { return }

            guard searchText.count >= 3 else {
                searchCityTable.cityList.removeAll()
                searchCityTable.tableView.reloadData()
                return
            }
            
            _ = ServiceManager.searchForCity(url: safeUrl) { cities, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
            }
            self.searchCityTable.cityList =  cities ?? [""]
            self.searchCityTable.tableView.reloadData()
            }
        }
    }
}
// MARK: = Custom protocol written to get the city name from tableview after city is chosen
extension AddCityViewController: TableCityDelegate {
    func citySelected(data: String) {
        title = data
        searchController.isActive = false
    }
}

