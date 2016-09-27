//
//  PokemonCellView.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import UIKit

class PokemonCellView: UICollectionViewCell {

    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!


    // MODIFY THE CONER RADIUS OF COLLECTION CELL
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 10
    }

    // CONFIGURE THE DATA INSIDE THE COLLECTION CELL
    func configureCell(_ pokemon: Pokemon)  {
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }

}
