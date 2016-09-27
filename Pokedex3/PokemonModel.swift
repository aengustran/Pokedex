//
//  PokemonModel.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!

    var name: String {


        return _name
    }


    var pokedexID: Int {



        return _pokedexID
    }


    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }

}

