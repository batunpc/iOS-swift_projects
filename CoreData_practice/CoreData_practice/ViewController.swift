//
//  ViewController.swift
//  CoreData_tuts
//
//  Created by Batuhan Ipci on 2022-08-08.
// notes:https://www.youtube.com/watch?v=gWurhFqTsPU

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //Reference to managed object context
    //let appDelegate = NSManagedObjectContext()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //viewContext here is an NSManagedObjectContext()
    
    //Data for the table
    //var items:[Person] = []
    var items:[Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        //Get items from Core Data
        fetchPeople()
    }
    func fetchPeople(){
        //fetch data from Core Data to display in the tableview
        do{
    
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            // set the filtering and sorting on the request
            let predicate = NSPredicate(format: "name CONTAINS %@", "Ted")
            request.predicate = predicate
            self.items = try appDelegate.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Error at fetching \(error)")
        }
    }
    //MARK: To create the user
    @IBAction func addTapped(_ sender: Any) {
        //Create alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default){ (action) in
            //Get the textfield for the alert
            let textField = alert.textFields![0]
            //Create a person object
            let newPerson = Person(context: self.appDelegate)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            //Save the data
            do{
                try self.appDelegate.save()
            }
            catch {
                print("Err:\(error)")
            }
            // Re-fetch the data
            //self.fetchPeople()
            // do the append method below when you only have to inster single object.Hence, there,s no need to call heavy tasks such as fetch
            self.items?.append(newPerson)
            self.tableView.insertRows(at: [IndexPath(row: (self.items!.count - 1), section: 0)], with: UITableView.RowAnimation.fade)
        }
        // Add button to the alert
        alert.addAction(submitButton)
        
        //Show alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of people
        return self.items?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = self.items![indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = person.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: To delete user
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //Which person to remove
            let deletedPerson = self.items![indexPath.row]
            //Remove the person
            self.appDelegate.delete(deletedPerson)
            //Save the data
            do{
                try self.appDelegate.save()
            }
            catch{
                print("Error:\(error)")
            }
            //Re-fetch the data
            self.fetchPeople()
        }
        //Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: To update user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Selected person
        let person = self.items![indexPath.row]
        //Create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        //Configure button handler
        let saveButton = UIAlertAction(title: "Save ", style: .default) { action in
            //Get the textfield for the alert
            let textField = alert.textFields![0]
            // Edit name property of person object
            person.name = textField.text
            // Save the data
            do{
               try self.appDelegate.save()
            }
            catch{
                print("Err at saving the data: \(error)")
            }
            //refresh
            self.fetchPeople()
        }
        //add the save button
        alert.addAction(saveButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }

}

