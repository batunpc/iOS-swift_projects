//
//  AddCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var selectedCity = ""
    var delegate : ServiceManagerDelegate?

    // Search controller
    lazy var searchController = UISearchController(searchResultsController: searchCityTableVC)
    lazy var searchCityTableVC = self.storyboard?.instantiateViewController(withIdentifier: "searchCityTableID") as! SearchCityTableViewController
    
    //ManagedObjectContext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<City>!

    // Get a reference to the Core Data persistent container
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        searchCityTableVC.delegate = self
        //=searchController
        title = "Search city"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        setUpFetchedResultsController()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async { //focus searchbar
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func saveBtn(_ sender: Any ) {
        //Save the selected city
        let city = City(context: context)
        //get data from openweatherAPI
        city.city_name = self.selectedCity // name
        ServiceManager.getWeatherData(with: URLState.openweather(city.city_name!).APIString) { data in
            city.city_temp = data.temperature //temp
            city.icon = data.icon // icon
            try? self.context.save() //saving to the coredata
            print("City has been saved")
        }
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: Search controller
extension AddCityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            guard let safeUrl = URL(string: URLState.geobytes(searchText).APIString) else { return }
            guard searchText.count >= 3 else {
                searchCityTableVC.cityList.removeAll()
                searchCityTableVC.tableView.reloadData()
                return
            }
            _ = ServiceManager.searchForCity(url: safeUrl) { cities, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
            }
            self.searchCityTableVC.cityList = cities ?? [""]
            self.searchCityTableVC.tableView.reloadData()
            }
        }
    }
    
}
// MARK: = Custom protocol written to get the city name from tableview after city is chosen
extension AddCityViewController: TableCityDelegate {
    func citySelected(data: String) {
   
        let cityName = data.components(separatedBy: ",")[0]
        title = cityName
        self.selectedCity = cityName
        print("City has been selected")
        //addCity(selectedCityName: cityName)
        
        searchController.isActive = false
    }
}

