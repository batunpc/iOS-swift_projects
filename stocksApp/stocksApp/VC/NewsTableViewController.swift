//
//  NewsTableViewController.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-20.
//

import UIKit
import CoreData
class NewsTableViewController: UITableViewController {
    
    lazy var resultSetNews = [NewsResponse](){ //Array of News titles
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPerformanceId()
    }
    
    func fetchPerformanceId(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        do {
          let result = try context.fetch(fetch)
          for data in result as! [NSManagedObject] {
              let performanceId = data.value(forKey: "performanceID")
              _ = ServiceManager.getNewsTitle(route: .newsTitles(performanceId as! String), method: .get) { response in
                  DispatchQueue.main.async { [unowned self] in
                      self.resultSetNews = response
                      print(resultSetNews)
              }
            }
          }
        } catch {
          print("Failed")
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  resultSetNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        cell.newsTitleLbl.text = resultSetNews[indexPath.row].title
        return cell
    }
}



