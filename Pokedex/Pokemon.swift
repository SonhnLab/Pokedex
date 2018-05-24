//
//  Pokemon.swift
//  Pokedex
//
//  Created by Son Ho on 5/23/18.
//  Copyright © 2018 Son Ho. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _baseAttack: Int!
    private var _nextEvolution: String!
    private var _pokemonUrl: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: Int {
        if _defense == nil {
            _defense = 0
        }
        return _defense
    }
    
    var height: Int {
        if _height == nil {
            _height = 0
        }
        return _height
    }
    
    var weight: Int {
        if _weight == nil {
            _weight = 0
        }
        return _weight
    }
    
    var baseAttack: Int {
        if _baseAttack == nil {
            _baseAttack = 0
        }
        return _baseAttack
    }
    
    var nextEvolution: String {
        if _nextEvolution == nil {
            _nextEvolution = ""
        }
        return _nextEvolution
    }
    
    var pokemonUrl: String {
        if _pokemonUrl == nil {
            _pokemonUrl = ""
        }
        return _pokemonUrl
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(BASE_URL)\(pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        let url = URL(string: pokemonUrl)!
        Alamofire.request(url).responseJSON() { response in
            guard
                let dict = response.result.value as? Dictionary<String, AnyObject>,
                let stats = dict["stats"] as? [Dictionary<String, AnyObject>],
                let types = dict["types"] as? [Dictionary<String, AnyObject>],
                let weight = dict["weight"] as? Int,
                let height = dict["height"] as? Int,
                let species = dict["species"] as? Dictionary<String, AnyObject> else {
                return
            }
            self._weight = weight
            self._height = height
            for statDict in stats {
                guard
                    let stat = statDict["stat"] as? Dictionary<String, AnyObject>,
                    let name = stat["name"] as? String,
                    let baseStat = statDict["base_stat"] as? Int else {
                    return
                }
                if name == "attack" {
                    self._baseAttack = baseStat
                } else if name == "defense" {
                    self._defense = baseStat
                } else {
                    continue
                }
            }
            var names = [String]()
            for typeDict in types {
                guard
                    let type = typeDict["type"] as? Dictionary<String, AnyObject>,
                    let name = type["name"] as? String else {
                    return
                }
                names.append(name.capitalized)
            }
            self._type = names.joined(separator: "/")
            let descriptionUrl = URL(string: species["url"] as! String)!
            Alamofire.request(descriptionUrl).responseJSON(completionHandler: { response in
                guard
                    let descriptionDict = response.result.value as? Dictionary<String, AnyObject>,
                    let entries = descriptionDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>],
                    let evolutionChain = descriptionDict["evolution_chain"] as? Dictionary<String, AnyObject> else {
                        return
                }
                for entry in entries {
                    guard
                        let language = entry["language"] as? Dictionary<String, AnyObject>,
                        let description = entry["flavor_text"] as? String,
                        let name = language["name"] as? String else {
                            return
                    }
                    if name == "en" {
                        let newDescription = description.replacingOccurrences(of: "\n", with: " ")
                        self._description = newDescription
                        break
                    } else {
                        continue
                    }
                }
                let envolutionUrl = URL(string: evolutionChain["url"] as! String)!
                Alamofire.request(envolutionUrl).responseJSON(completionHandler: { response in
                    guard
                        let evolutionDict = response.result.value as? Dictionary<String, AnyObject>,
                        let chain = evolutionDict["chain"] as? Dictionary<String, AnyObject>,
                        let evolvesTo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] else {
                        return
                    }
                    if evolvesTo.count > 0 {
                        guard
                            let evolutionDetails = evolvesTo[0]["evolution_details"] as? [Dictionary<String, AnyObject>],
                            let species = evolvesTo[0]["species"] as? Dictionary<String, AnyObject>,
                            let name = species["name"] as? String else {
                            return
                        }
                        if evolutionDetails.count > 0 {
                            guard
                                let minLevel = evolutionDetails[0]["min_level"] as? Int else {
                                return
                            }
                            self._nextEvolution = "Next Evolution: \(name.capitalized) LVL \(minLevel)"
                        }
                    }
                    completed()
                })
                completed()
            })
            completed()
        }
    }
    
    
}
