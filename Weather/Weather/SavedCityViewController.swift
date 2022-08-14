//
//  SavedCityViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import UIKit
import CoreData

class SavedCityViewController: UIViewController {
    
    @IBOutlet weak var savedCitiesTable: UITableView!
    
    let searchController = UISearchController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[City]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // searchController parameters setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search saved city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegueId" {
            print("going")
        }
    }
    
    //fetch data from Core Data to display in the tableview
    func fetchPeople(){
        do{
            let request = City.fetchRequest() as NSFetchRequest<City>
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.savedCitiesTable.reloadData()
            }
        }
        catch{
            print("Error at fetching \(error)")
        }
    }
    
}


// MARK: - Table view data source
extension SavedCityViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCityCell", for: indexPath)
        cell.textLabel?.text = ("Section \(indexPath.row)")
        return cell
    }
}


// MARK: - Search controller
extension SavedCityViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        //print(text)
    }
}
    

