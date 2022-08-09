//
//  ViewController.swift
//  NasaAPI_rover
//
//  Created by Batuhan Ipci on 2022-08-06.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var resultSet = [Photo](){
        didSet{
            tableView.reloadData()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        Service.getInfo(iUrl: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY") { result in
            
            DispatchQueue.main.async { [unowned self] in
                self.resultSet = result.photos
                print(resultSet)
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
            RoverImagesTableViewCell
        cell.dateLbl.text = resultSet[indexPath.row].earth_date
        
        let urlString = resultSet[indexPath.row].img_src
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.rImage.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
    
        }
    return cell
    }

}
