//
//  NetworkService.swift
//  Image_viewer
//
//  Created by Batuhan Ipci on 2022-07-11.
//

import Foundation
import UIKit

class NetworkService {
    func downloadImg(urlString : String, imgView : UIImageView, completion : @escaping (Data?) -> ()){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("There was an error at Service: \(error.localizedDescription)")
                }else{
                    if let safeData = data{
                        if let img = UIImage(data: safeData){
                            DispatchQueue.main.async {
                                imgView.image = img
                            }
                        }
                    }
                }
                completion(data)
            }
            task.resume()
        }
    }
}
