//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Yerlan Ismailov on 11.07.16.
//  Copyright © 2016 ismailov.com. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    var pokemon:Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalizedString
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails({
            self.updateUI()
        })

    }
    
    func updateUI() {
        
        self.descriptionLbl.text = self.pokemon.description
        self.weightLbl.text = self.pokemon.weight
        self.heightLbl.text = self.pokemon.height
        self.typeLbl.text = self.pokemon.type
        self.defenseLbl.text = self.pokemon.defense
        self.pokedexIdLbl.text = "\(self.pokemon.pokedexId)"
        self.baseAttackLbl.text = self.pokemon.baseAttack
        self.nextEvoImg.image = UIImage(named: self.pokemon.nextEvoId)
        self.currentEvoImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        self.evoLbl.text = self.pokemon.nextEvoTxt
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
