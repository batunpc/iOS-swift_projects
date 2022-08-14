//
//  AddCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet weak var cityTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentSearchTask: URLSessionTask?
     //var cityList : [String]? = []
    lazy var cityList = [String]() {
        didSet{
            DispatchQueue.main.async {
                self.cityTable.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView
        cityTable.delegate = self
        cityTable.dataSource = self
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
// MARK: - Search controller
extension AddCityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text {
            let url = URLState.geobytes(searchText).stringValue
                ServiceManager.searchCity(from: url) { result in
                    switch result {
                    case.failure(let error):
                        print(error)
                    case.success(let data):
                        let decoder = JSONDecoder()
                        if let searchResults = try? decoder.decode([String].self, from: data){
                            self.cityList = searchResults
                            print(searchResults)
                    }
                }
            }
        }
    }
}
extension AddCityViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text{
            
        }
    }
}

// MARK: - Table view data source
extension AddCityViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        let city = cityList[indexPath.row]
        cell.textLabel?.text = city.components(separatedBy: ",")[0]
        let count = cityList.count
            guard count > 2 && cell.textLabel?.text != nil else {
                return cell
            }
            cell.detailTextLabel?.text = city.components(separatedBy: ",")[2]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityList[indexPath.row]
        title = city
        searchController.isActive = false
    }
}


    

