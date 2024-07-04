//
//  CoreDataManager.swift
//  RickCoreData
//
//  Created by Рахим Габибли on 04.07.2024.
//

import Foundation

import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "RickCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private init() {}

    func getAllCharacters(_ complition: @escaping ([Character]) -> Void) {
        let viewContext = persistentContainer.viewContext

        viewContext.perform {
            let characterEntities = try? CharacterEntity.all(viewContext)
            let dbCharacters = characterEntities?.map({ Character(entity: $0) })

            complition(dbCharacters ?? [] )
        }
    }

    func save (characters: [Character], complition: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for character in characters {
                _ = try? CharacterEntity.findOrCreate(character, context: viewContext)
            }

            try? viewContext.save()

            complition()
        }
    }
}
