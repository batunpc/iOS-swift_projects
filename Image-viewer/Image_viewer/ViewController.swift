//
//  ViewController.swift
//  Image_viewer
//
//  Created by Batuhan Ipci on 2022-07-11.
//

import UIKit

class ViewController: UIViewController {
    
    let planets = Array(Model().listOfImages)
    var index = 0
    
    @IBOutlet weak var planetImg: UIImageView!
    @IBOutlet weak var choosePlanetPC: UIPickerView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        choosePlanetPC.delegate = self
        choosePlanetPC.dataSource = self
        
        spinner.hidesWhenStopped = true
        planetImg.isUserInteractionEnabled = true
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureFired(_:)))

        swipeRightGesture.direction = .right
        swipeLeftGesture.direction = .left
        
        planetImg.addGestureRecognizer(swipeRightGesture)
        planetImg.addGestureRecognizer(swipeLeftGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        getData(url: planets[index].value, planetImg: planetImg)
        super.viewWillAppear(animated)
    }
    
    //MARK: helper function for NetworkService
    func getData(url:String, planetImg : UIImageView){
        let networkService = NetworkService()
        spinner.startAnimating()
        networkService.downloadImg(urlString: url , imgView: planetImg) { data in
            if let safeData = data{
                if let img = UIImage(data: safeData){
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.planetImg.image = img
                    }
                }
            }
        }
    }
}

//MARK: planet picker view setup
extension ViewController : UIPickerViewDataSource , UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planets.count //num of element in dictionary
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getData(url: planets[row].value, planetImg: planetImg)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerRow = UILabel(frame:  CGRect(x:100, y: 100, width: 100, height: 100))
        pickerRow.text = planets[row].key
        pickerRow.textColor = UIColor.white
        pickerRow.font =  UIFont(name: "Arial", size: 25)
        pickerRow.textAlignment = NSTextAlignment.center
        return pickerRow
    }

//MARK: UISwipeGesture Helpers
    func previous() -> Int{
        if index < planets.count - 1 {
            index += 1
        } else if index == planets.count - 1 {
            index = 0
        }
        return index
    }
    func following() -> Int {
        if index > 0 {
            index -= 1
        } else if index == 0 {
            index = planets.count - 1
        }
        return index
    }
    
    @objc func gestureFired(_ gesture: UISwipeGestureRecognizer){
        if (gesture.direction == .right) {
            choosePlanetPC.selectRow(following(), inComponent : 0, animated: true)
            getData(url: planets[index].value, planetImg: planetImg)
        }
        if (gesture.direction == .left){
            choosePlanetPC.selectRow(previous(), inComponent: 0, animated: true)
            getData(url: planets[index].value, planetImg: planetImg)
        }
    }
}
