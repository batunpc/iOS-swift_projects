//
//  Model.swift
//  NasaAPI_rover
//
//  Created by Batuhan Ipci on 2022-08-06.
//

import Foundation

struct  RoverAPIResult :  Codable{
    let photos : [Photo]
}

struct Photo : Codable{
    let img_src: String //url string
    let earth_date: String
   let rover : Rover
}

struct Rover : Codable {
    let name : String
}
