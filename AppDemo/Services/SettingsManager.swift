//
//  SettingsManager.swift
//  AppDemo
//
//  Created by Sabrina Bonates on 07/02/22.
//

import Foundation

final class SettingsManager {
    static func isFavorite(_ id: Int) -> Bool {
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.V45SL99ZK4.AppDemo.appClipMigration") else {
            return false
        }
        return sharedUserDefaults.bool(forKey: "\(id)")
    }
    
    static func setFavorite(_ id: Int, isFavorite: Bool) {
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.V45SL99ZK4.AppDemo.appClipMigration") else {
            return
        }
        sharedUserDefaults.setValue(isFavorite, forKey: "\(id)")
        sharedUserDefaults.synchronize()
    }
}

