import SwiftUI

struct ContentView: View {
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
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                } else {
                    List(filteredPokemons) { pokemon in
                        NavigationLink {
                            DetailView(pokemon: pokemon)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                            }
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

struct DetailView: View {
    let pokemon: Pokemon
    @State private var pokemonDetail: PokemonDetail?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
                
                if let detail = pokemonDetail {
                    VStack(spacing: 15) {
                        Text(detail.name.capitalized)
                            .font(.title)
                            .bold()
                        
                        // Correction de la partie des types
                        HStack(spacing: 10) {
                            ForEach(detail.types, id: \.pokemonType.name) { typeElement in
                                Text(typeElement.pokemonType.name.capitalized)
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Taille: \(Double(detail.height) / 10) m")
                            Text("Poids: \(Double(detail.weight) / 10) kg")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
        }
        .task {
            do {
                pokemonDetail = try await PokemonService.shared.fetchPokemonDetail(id: pokemon.id)
            } catch {
                print("Erreur: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
