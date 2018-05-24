//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Son Ho on 5/23/18.
//  Copyright © 2018 Son Ho. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemon.name.capitalized
        pokemonImage.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvolutionImage.image = UIImage(named: "\(pokemon.pokedexId)")
        nextEvolutionImage.image = UIImage(named: "\(pokemon.pokedexId + 1)")
        
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        typeLabel.text = pokemon.type
        defenseLabel.text = "\(pokemon.defense)"
        heightLabel.text = "\(pokemon.height)"
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        weightLabel.text = "\(pokemon.weight)"
        baseAttackLabel.text = "\(pokemon.baseAttack)"
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
