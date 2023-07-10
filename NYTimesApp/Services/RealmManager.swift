//
//  RealmManager.swift
//  NYTimesApp
//
//  Created by Dmytro Besedin on 10.07.2023.
//

import SwiftUI
import RealmSwift

final class RealmManager: ObservableObject {
    static let shared = RealmManager()
    
    private func realm() throws -> Realm {
        let config = Realm.Configuration(schemaVersion: 1)
        
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    
        return try Realm()
    }
}
