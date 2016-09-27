//
//  PokemonAPIParser.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import Foundation
import Alamofire

typealias DownloadComplete = () -> ()


func PokemonAPIParser(pokemonIdentifier: Int, completed: @escaping DownloadComplete) {
    Alamofire.request("http://pokeapi.co/api/v1/pokemon/\(pokemonIdentifier)/").responseJSON { (response) in
        if let resultJSONDiction = response.result.value as? Dictionary<String, AnyObject> {

            // PARSING POKEMON WEIGHT
            if let weight = resultJSONDiction["weight"] as? String {
                print(weight)
            }

            // PARSING POKEMON HEIGHT
            if let height = resultJSONDiction["height"] as? String {
                print(height)
            }

            // PARSING POKEMON ATTACK
            if let attack = resultJSONDiction["attack"] as? Int {
                print(attack)
            }

            //// PARSING POKEMON DEFENSE
            if let defense = resultJSONDiction["defense"] as? Int {
                print(defense)
            }

            // PARSING POKEMON SPECIES
            if let attack = resultJSONDiction["species"] as? Int {
                print(attack)
            }

            //// PARSING POKEMON NAME
            if let name = resultJSONDiction["name"] as? String {
                print(name.capitalized)
            }

            //// PARSING POKEMON TPE
            if let typeArray = resultJSONDiction["types"] as? [Dictionary<String, AnyObject>] {
                for eachType in typeArray {
                    if let type = eachType["name"] as? String {
                        print(type.capitalized)
                    }
                }
            }


            
        }


    completed ()
    }
}

