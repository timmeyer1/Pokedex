import SwiftUI

struct PokemonDetailView: View {
    let pokemonId: Int
    @State private var pokemonDetail: PokemonDetail?
    
    var body: some View {
        ScrollView {
            if let detail = pokemonDetail {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(detail.id).png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                    
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
        .task {
            do {
                pokemonDetail = try await PokemonService.shared.fetchPokemonDetail(id: pokemonId)
            } catch {
                print("Erreur: \(error)")
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemonId: 1)
    }
}
