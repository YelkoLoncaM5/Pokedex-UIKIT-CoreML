//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 1/04/24.
//

import UIKit

class PokemonViewModel {
    
    var pokemon = [Pokemon]()
    
    init() {
        loadPokemonFromLocalFile()
    }
    
    private func loadPokemonFromLocalFile() {
        guard let url = Bundle.main.url(forResource: "Pokemons", withExtension: "json") else {
            print("No se pudo encontrar el archivo Pokemons.json")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(PokemonList.self, from: data)
            self.pokemon = decodedData.results
        } catch {
            print("Error al cargar o decodificar el archivo Pokemons.json: \(error)")
        }
    }
    
    func findPokemon(byName name: String) -> Pokemon? {
        return pokemon.first { $0.name.lowercased() == name.lowercased() }
    }
    
    func backgroundColor(forType type: String) -> UIColor {
        switch type {
        case "fire": return .systemRed
        case "poison": return .systemGreen
        case "water": return .systemBlue
        case "electric": return .systemYellow
        case "psychic": return .systemPurple
        case "normal": return .systemOrange
        case "ground": return .systemGray
        case "flying": return .systemTeal
        case "fairy": return .systemPink
        default: return .systemIndigo
        }
    }
    
}
