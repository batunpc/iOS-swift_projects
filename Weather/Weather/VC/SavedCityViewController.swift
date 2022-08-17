//
//  SavedCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit
import CoreData

class SavedCityViewController: UIViewController  {
    
    @IBOutlet weak var savedCitiesTable: UITableView!
    
    //CoreData reference
    var city: City!
    //Custom protocol
    var delegate : ServiceManagerDelegate?
    //SearchController
    let searchController = UISearchController()
    // Empty array consisting the type WeatherModel data
    lazy var weatherResultSet = [WeatherModel](){
        didSet{
            DispatchQueue.main.async {
                self.savedCitiesTable.reloadData()
            }
        }
    }
    
    // MARK: CoreData
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<City>! // fetch from coredata
    
    func fetchSavedCityResults() {
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
            self.delegate?.didTaskFail(error: error)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCitiesTable.delegate = self
        savedCitiesTable.dataSource = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search saved city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        fetchSavedCityResults()
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
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCityCell", for: indexPath) as!
            WeatherImgTableViewCell
    
        let city = fetchedResultsController.object(at: indexPath)
        cell.cityNameLbl.text = city.city_name
        cell.cityTempLbl.text = String(city.city_temp)

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
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let deletedCity = self.fetchedResultsController.object(at: indexPath)
            self.context.delete(deletedCity)
            try? self.context.save()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: FetchedResultsControllerDelegate
extension SavedCityViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCitiesTable.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savedCitiesTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
            fatalError("Aborting")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            savedCitiesTable.insertSections(indexSet, with: .fade)
        case .delete:
            savedCitiesTable.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Abort the request")
        @unknown default:
            fatalError("Aborting")
        }
    }
}
