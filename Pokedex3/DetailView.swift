//
//  DetailView.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet weak var pokemonImage: UIImageView!

    func updateImage(ID id:Int)  {
        pokemonImage.image = UIImage(named: "\(id)")
    }

}
