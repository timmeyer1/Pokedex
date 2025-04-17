import Foundation

// Structure principale pour la liste des Pokémon
struct Pokemon: Identifiable, Codable {
    let id: Int
    let name: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
    }
    
    struct Sprites: Codable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        imageUrl = sprites.frontDefault
    }
    
    // Ajout de l'encodage
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        let sprites = Sprites(frontDefault: imageUrl)
        try container.encode(sprites, forKey: .sprites)
    }
}

// Structure pour les détails d'un Pokémon
struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    
    struct TypeElement: Codable {
        let pokemonType: PokemonType
        
        struct PokemonType: Codable {
            let name: String
        }
        
        enum CodingKeys: String, CodingKey {
            case pokemonType = "type"
        }
    }
}
