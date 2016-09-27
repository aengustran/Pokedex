//
//  ViewController.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import UIKit

class BrowserController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {


    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    var pokemonArray = [Pokemon]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // SET UP DATA SOURCE AND DELEGATE
        parsePokemonCSV()
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self

    }



    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows

            for eachRow in rows {
                let pokemonID = Int(eachRow["id"]!)!
                let name = eachRow["identifier"]!
                pokemonArray.append(Pokemon(name: name, pokedexID: pokemonID))
            }

        }catch{

        }
    }


    // SETTING UP THE CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCellViewIdentifier", for: indexPath) as? PokemonCellView {

            cell.configureCell(pokemonArray[indexPath.row])

            return cell
        } else {
            return UICollectionViewCell()
        }
    }


    // EXECUTE WHEN A COLLECTION CELL IS SELECTED
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // SET UP THE NUMBER OFS SECTION IN COLLECTION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // SET UP THE NUMBER OF ITEMS IN SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return pokemonArray.count
    }

    // SET UP THE SIZE OF EACH CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 105, height: 105)
    }

}

