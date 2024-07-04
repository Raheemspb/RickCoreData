//
//  NetworkManager.swift
//  RickCoreData
//
//  Created by Рахим Габибли on 04.07.2024.
//

import Foundation

struct ReturnedClass: Codable {
    let results: [Character]
}

struct Character: Codable {
    let name: String
    let image: String
    let species: String
    let gender: String
    let status: String
    let origin: Location

    init(entity: CharacterEntity) {
        self.name = entity.name ?? ""
        self.image = entity.image ?? ""
        self.species = entity.species ?? ""
        self.gender = entity.gender ?? ""
        self.status = entity.status ?? ""
        self.origin = Location(name: entity.name ?? "")
    }

}

struct Location: Codable {
    let name: String
}

class NetworkManager {

    let urlString = "https://rickandmortyapi.com/api/character"

    func getCharacters(complition: @escaping ([Character]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error URL")
            complition([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: ", error.localizedDescription)
                complition([])
                return
            }
            guard let data else {
                print("No data")
                complition([])
                return
            }

            do {
                let character = try JSONDecoder().decode(ReturnedClass.self, from: data).results
                print("Good")
                complition(character)
            } catch {
                print("Catch")
            }
        }.resume()

    }

}
