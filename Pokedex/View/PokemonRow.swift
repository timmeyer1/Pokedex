//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Stagiaire on 17/04/2025.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            Text(pokemon.name.capitalized)
                .font(.headline)
        }
    }
}
