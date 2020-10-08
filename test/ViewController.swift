//
//  ViewController.swift
//  test
//
//  Created by Efe Mazlumoğlu on 8.10.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        fetchPokemon(id: 1)
    }
    
    func fetchPokemon(id: Int) {
        PokeManager.pokemon(id: id) { (pokemon) in
            self.name.text = pokemon.species.name
          PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
            self.image.image = image
          }
        }
    }
    
    func registerForNotifications() {
      NotificationCenter.default.addObserver(
        forName: .newPokemonFetched,
        object: nil,
        queue: nil) { (notification) in
          print("notification received")
          if let uInfo = notification.userInfo,
             let pokemon = uInfo["pokemon"] as? Pokemon {
            self.updateWithPokemon(pokemon)
          }
      }
    }

    func updateWithPokemon(_ pokemon: Pokemon) {
        self.name.text = pokemon.species.name
      PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
        self.image.image = image
      }
    }
}

