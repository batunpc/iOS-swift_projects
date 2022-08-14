//
//  Service.swift
//  NasaAPI_rover
//
//  Created by Batuhan Ipci on 2022-08-06.
//

import Foundation
import UIKit

class Service{
    private init(){}
    //static var shared = Service()
    
    static func getInfo(iUrl: String, complition : @escaping (RoverAPIResult)->()){
        
        guard let xurl = URL(string: iUrl) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: xurl) { data, response, error in
            if error == nil && data != nil{
                //parse JSON
                let decoder = JSONDecoder()
        
                do{
                    let roverapi = try decoder.decode(RoverAPIResult.self, from: data!)
                    complition(roverapi)
                }
                catch{
                    print("Error in JSON Parsing \(error)")
                }
                
            }
        }
        task.resume()

     
    }
        
}
    

