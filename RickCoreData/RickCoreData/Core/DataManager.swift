//
//  DataManager.swift
//  RickCoreData
//
//  Created by Рахим Габибли on 04.07.2024.
//

import Foundation

class DataManager {
    let coreDataManager = CoreDataManager.shared
    let networkManager = NetworkManager()

    func getCharacters(complition: @escaping ([Character]) -> Void) {
        coreDataManager.getAllCharacters { characters in
            if characters.count > 0 {
                print("From CoreData")
                complition(characters)
            } else {
                print("From network")
                self.networkManager.getCharacters { characters in
                    self.coreDataManager.save(characters: characters) {
                        //  save to CoreData
                        complition(characters)
                    }

                }
            }
        }
    }
}
