//
//  Pokemon.swift
//  pokedex
//
//  Created by Yerlan Ismailov on 10.07.16.
//  Copyright © 2016 ismailov.com. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvoTxt: String?
    private var _pokemonUrl: String!
    private var _nextEvoId: String?
    private var _nextEvoLvl: String!
    private var _nextEvolName: String!
    
    var name: String {
        get {
            return _name
        }
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        return self._description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return self._type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return self._defense
    }
    
    var height: String {
        return self._height
    }
    
    var weight: String {
        return self._weight
    }
    
    var baseAttack: String {
        return self._baseAttack
    }
    
    var nextEvoTxt: String {
        if let nextTxt = self._nextEvoTxt {
            return nextTxt
        }else {
            return ""
        }
    }
    
    var nextEvoId: String {
        if let evoID = self._nextEvoId {
            return evoID
        }else {
            return ""
        }
    }
    
    var nextEvolName: String {
        if _nextEvolName == nil {
            _nextEvolName = ""
        }
        return _nextEvolName
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String{
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? String{
                    self._height = "\(height)"
                }
                if let attack = dict["attack"] as? Int{
                    self._baseAttack = "\(attack)"
                }
                if let defense = dict["defense"] as?Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                    if types.count > 1 {
                        for i in 1 ..< types.count {
                            if let typeName = types[i]["name"] {
                                self._type! += ", \(typeName)"
                            }
                        }
                    }
                }else {
                    self._type = ""
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] where descriptions.count > 0 {
                    if let descUrl = descriptions[0]["resource_uri"] {
                        let url = NSURL(string: "\(URL_BASE)\(descUrl)")!
                        Alamofire.request(.GET, url).responseJSON(completionHandler: { response in
                            let result = response.result
                            if let dictDesc = result.value as? Dictionary<String, AnyObject> {
                                if let descr = dictDesc["description"] as? String {
                                    self._description = descr
                                }
                            }
                            completed()
                        })
                    }
                    
                }else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                    var str = ""
                    if let evolName = evolutions[0]["to"] as? String{
                        //Currently Not able to suppeort mega pokemons
                        if evolName.rangeOfString("mega") == nil {
                            if let evoNextUrl = evolutions[0]["resource_uri"] as? String {
                                let idFromUri = evoNextUrl.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "").stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvoId = idFromUri
                                self._nextEvolName = evolName
                                str += "Next evolution: \(evolName)"
                            }
                        }else {
                            self._nextEvoTxt = "Next evolution is mega"
                        }
                    }
                    if let evolLevel = evolutions[0]["level"] as? Int{
                        self._nextEvoLvl = "\(evolLevel)"
                        str += " LVL \(evolLevel)"
                    }
                    self._nextEvoTxt = str
                    
                }else {
                    self._nextEvoTxt = "No evolution"
                }
                
            }
        }
    }
}
