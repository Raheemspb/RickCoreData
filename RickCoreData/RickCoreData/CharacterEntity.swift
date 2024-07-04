//
//  CharacterEntity.swift
//  RickCoreData
//
//  Created by Рахим Габибли on 04.07.2024.
//

import Foundation
import CoreData

class CharacterEntity: NSManagedObject {

    class func findOrCreate(_ character: Character, context: NSManagedObjectContext) throws -> CharacterEntity {

        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %d", character.name)

        do {
            let fetchResult = try context.fetch(request)

            if fetchResult.count > 1 {
                assert(fetchResult.count == 1, "Duplicate")
                return fetchResult[0]
            }
        } catch {
            throw error
        }

        let characterEntity = CharacterEntity(context: context)

        characterEntity.name = character.name
        characterEntity.image = character.image
        characterEntity.species = character.species
        characterEntity.gender = character.gender
        characterEntity.status = character.status
        characterEntity.origin = character.origin.name

        return characterEntity

    }

    class func all(_ context: NSManagedObjectContext) throws -> [CharacterEntity] {

        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
