//
//  LocationsManager.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocations()
    func locationSelected(_ location: Location)
}

class LocationsManager: NSObject {

    weak var delegate: LocationManagerDelegate?
    
    var locations = [Location]() {
        didSet {
            delegate?.didUpdateLocations()
        }
    }
    
    var selectedLocation: Location = .empty {
        didSet {
            delegate?.locationSelected(selectedLocation)
        }
    }
    
    override init() {
        super.init()
        setupData()
    }
    
    func setupData() {
        do {
            try getLocations { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    print(error.errorMessage)
                case .success(let locations):
                    self.locations = locations
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func getLocations(completion: @escaping (Result<[Location], APIError>) -> Void) throws {
        
        guard let dataURL = Bundle.main.url(forResource: "json/locations", withExtension: "json") else {
            throw APIError.invalidURL
        }
        
        let locationResource = Resource<[Location]>(request: URLRequest(url: dataURL), parse: { data in
            
            let decoder = JSONDecoder()
            do {
                let allLocationsSource = try decoder.decode(LocationsSourceArray.self, from: data)
                return allLocationsSource.listLocations.compactMap(Location.init(from:))
            } catch let error {
                print(error.localizedDescription)
            }
            
            return []
        })

        WebService.loadLocal(resource: locationResource, completion: { allLocations in
            if let allLocations = allLocations {
                completion(.success(allLocations))
            } else {
                completion(.failure(.noData))
            }
        })
    }

    static func getLocationDetail(id: Int, completion: @escaping (Result<LocationDetail, APIError>) -> Void) throws {
        
        guard let dataURL = Bundle.main.url(forResource: "json/\(id)", withExtension: "json") else {
            throw APIError.invalidURL
        }
        
        let locationResource = Resource<LocationDetail>(request: URLRequest(url: dataURL), parse: { data in
            
            let decoder = JSONDecoder()
            do {
                let location = try decoder.decode(LocationDetailSource.self, from: data)
                return LocationDetail(from: location)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            return nil
        })

        WebService.loadLocal(resource: locationResource, completion: { allLocations in
            if let allLocations = allLocations {
                completion(.success(allLocations))
            } else {
                completion(.failure(.noData))
            }
        })
    }

}
