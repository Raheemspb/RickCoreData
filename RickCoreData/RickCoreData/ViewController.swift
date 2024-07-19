//
//  ViewController.swift
//  RickCoreData
//
//  Created by Рахим Габибли on 04.07.2024.
//

import UIKit
import CoreData
import SnapKit

class ViewController: UIViewController {

    var tableView: UITableView!
    let image = UIImageView()
    let networkManager = NetworkManager()
    let dataManager = DataManager()

    var characters = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.rowHeight = 150

        dataManager.getCharacters { [weak self] characters in
            self?.characters = characters

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.dataSource = self

        tableView.snp.makeConstraints { make in
            make.top.bottom.height.width.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(characters.count)
        return characters.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? CustomTableViewCell else { return UITableViewCell() }

        let character = characters[indexPath.row]

        guard let url = URL(string: self.characters[indexPath.row].image) else { return cell }
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell else { return }
                cell.configure(
                    imageData: imageData,
                    name: character.name,
                    species: character.species,
                    gender: character.gender,
                    origin: character.origin.name,
                    status: character.status
                )
            }
        }
        return cell
    }
}
