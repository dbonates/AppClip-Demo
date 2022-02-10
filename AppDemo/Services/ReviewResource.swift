//
//  ReviewResource.swift
//  AppDemo
//
//  Created by Daniel Bonates on 10/12/21.
//

import Foundation


struct ReviewResource: Decodable {
    let rating: Float
    let title: String
    let info: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case rating = "rating"
        case title = "subject"
        case info = "content"
        case name = "username"
    }
}
