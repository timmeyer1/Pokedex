//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Stagiaire on 17/04/2025.
//

import SwiftUI

struct PokemonListView: View {
    @State private var pokemons: [Pokemon] = []
    @State private var searchText = ""
    @State private var isLoading = true
    
    var filteredPokemons: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        }
        return pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(filteredPokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonId: pokemon.id)) {
                            PokemonRow(pokemon: pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .searchable(text: $searchText, prompt: "Rechercher un Pokémon")
        }
        .task {
            do {
                pokemons = try await PokemonService.shared.fetchPokemons()
                isLoading = false
            } catch {
                print("Erreur: \(error)")
            }
        }
    }
}
