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
            guard let safeUrl = URL(string: URLState.geobytes(searchText).APIString) else { return }

            guard searchText.count >= 3 else {
                cityList.removeAll()
                cityTable.reloadData()
                return
            }
            
            _ = ServiceManager.searchForCity(url: safeUrl) { cities, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.cityList = cities ?? [""]
                self.cityTable.reloadData()
            }
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


    

