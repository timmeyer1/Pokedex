import Foundation

class PokemonService {
    static let shared = PokemonService()
    private let baseURL = "https://pokeapi.co/api/v2"
    
    private init() {}
    
    struct PokemonResults: Codable {
        let results: [PokemonEntry]
        
        struct PokemonEntry: Codable {
            let url: String
        }
    }
    
    func fetchPokemons() async throws -> [Pokemon] {
        guard let url = URL(string: "\(baseURL)/pokemon?limit=500") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(PokemonResults.self, from: data)
        
        var pokemons: [Pokemon] = []
        for pokemonEntry in result.results {
            if let detailURL = URL(string: pokemonEntry.url) {
                let (detailData, _) = try await URLSession.shared.data(from: detailURL)
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: detailData)
                pokemons.append(pokemon)
            }
        }
        return pokemons
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
}
