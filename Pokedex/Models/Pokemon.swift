//
//  Pokemon.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 1/04/24.
//

struct PokemonList: Decodable {
    
    let results: [Pokemon]
    
}

struct Pokemon: Decodable {
    
    let id:Int
    let name:String
    let imageUrl:String
    let type:String
    let description:String
    let height:Int
    let weight:Int
    let attack: Int
    let defense: Int
    
}
