//
//  SearchCityTableViewController.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-14.
//

import UIKit

class SearchCityTableViewController: UITableViewController {
    
    //Custom protocol
    weak var delegate : TableCityDelegate?
    // Empty array of string to hold cities with didset to handle UI update
    lazy var cityList = [String]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cityList[indexPath.row]
        cell.textLabel?.text = city.components(separatedBy: ",")[0]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityList[indexPath.row]
        delegate?.citySelected(data: city)
        
    }

}
