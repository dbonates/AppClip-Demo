//
//  Resource.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation

struct Resource<T> {
    var request: URLRequest
    var parse: (Data) -> T?
}
