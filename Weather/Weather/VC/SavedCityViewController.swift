//
//  SavedCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit
import CoreData

class SavedCityViewController: UIViewController  {

    var city: City!

    let searchController = UISearchController()
    @IBOutlet weak var savedCitiesTable: UITableView!

   // var weatherResultSet = [WeatherModel]()
    // var stringCityName = ""
    //let fetchedResultsController:NSFetchedResultsController<City>!
    lazy var weatherResultSet = [WeatherModel](){
        didSet{
            DispatchQueue.main.async {
                self.savedCitiesTable.reloadData()
            }
        }
    }
    
    // CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<City>!
    
    func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "city_name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "city_name", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ServiceManager.getWeatherData(with: URLState.openweather(city.city_name ?? "").APIString) { data in
//            self.weatherResultSet = [data]
//            city.city_temp = data.temperature
//            city.icon = data.icon
//        }
        //self.citySelected(data: <#T##String#>)
      
        savedCitiesTable.delegate = self
        savedCitiesTable.dataSource = self
        // searchController parameters setup
        //searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search saved city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setUpFetchedResultsController()
  
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpFetchedResultsController()
        //searchView.text = ""
        savedCitiesTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegueId" {
            let searchVC = segue.destination as? AddCityViewController
            searchVC?.context = context
        }
    }
}



// MARK: - Table view data source
extension SavedCityViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        //print("asdfsdfasdfDSAFASDF",weatherResultSet)
        return fetchedResultsController.sections?.count ?? 1
        //return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        //return weatherResultSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCityCell", for: indexPath) as!
            WeatherImgTableViewCell
    
        let city = fetchedResultsController.object(at: indexPath)
        cell.cityNameLbl.text = city.city_name
        cell.cityTempLbl.text = String(city.city_temp)
        
        print("TEMPERATURE", String(city.city_temp))
        
        print("ICON:::::::",city.icon ?? "")
        //print("ICON:::::::",urlString)
        

        if let url = URL(string: "http://openweathermap.org/img/wn/\(city.icon ?? "")@2x.png") {
            let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in

                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell.weatherImg.image = UIImage(data: data)
                    }
                }
            }
            task.resume()

        }
        //cell.cityTempLbl.text = city.city_temp

        return cell
    }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCityCell", for: indexPath) as!
//            WeatherImgTableViewCell
//
//        let city = fetchedResultsController.object(at: indexPath)
//        let iconID = weatherResultSet[indexPath.row].icon
//
//

        
}


// MARK: Extension for FetchedResultsControllerDelegate methods to automatically track and update the UI
extension SavedCityViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCitiesTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCitiesTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            savedCitiesTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            savedCitiesTable.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            savedCitiesTable.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            savedCitiesTable.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            savedCitiesTable.insertSections(indexSet, with: .fade)
        case .delete:
            savedCitiesTable.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
    
        @unknown default:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }



// MARK: - Search controller
//extension SavedCityViewController : UISearchResultsUpdating{
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else {return}
//        print(text)
//    }
//}


    }
}
