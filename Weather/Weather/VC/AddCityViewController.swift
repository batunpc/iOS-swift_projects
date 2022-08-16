//
//  AddCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // Search controller
    lazy var searchController = UISearchController(searchResultsController: searchCityTable)
    lazy var searchCityTable = self.storyboard?.instantiateViewController(withIdentifier: "searchCityTableID") as! SearchCityTableViewController
    
    //ManagedObjectContext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<City>!

    // Get a reference to the Core Data persistent container
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var weatherResultSet = [WeatherModel]()
    
    func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city_name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "city_name", cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //=Custom protocol
        searchCityTable.delegate = self
        //=searchController
        title = "Search city"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        setUpFetchedResultsController()
    }
    
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func saveBtn(_ sender: Any) {
        
    }
    
    func addCity(component: String) {
        
        let city = City(context: context)
        // separate city name from province and country in the response string
        city.city_name = component.components(separatedBy: ",")[0]
        do{
            try self.context.save()
        }catch {
            print("Err:\(error.localizedDescription)")
        }
    }
}


// MARK: Search controller
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
            self.searchCityTable.cityList = cities ?? [""]
            self.searchCityTable.tableView.reloadData()
            }
        }
    }
    
}
// MARK: = Custom protocol written to get the city name from tableview after city is chosen
extension AddCityViewController: TableCityDelegate {
    func citySelected(data: String) {
   
        let cityName = data.components(separatedBy: ",")[0]
        title = cityName
        addCity(component: cityName)
        
        searchController.isActive = false
    }
}

