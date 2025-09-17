import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
    
    
    
    private enum CodingKeys: String, CodingKey {
        case errorMessage
        case items
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        self.items = try container.decode([MostPopularMovie].self, forKey: .items)
    }
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    enum ParsingError: Error {
        case invalidURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decode(String.self, forKey: .rating)
        let imageURL = try container.decode(String.self, forKey: .imageURL)
        guard let url = URL(string: imageURL) else { throw ParsingError.invalidURL }
        self.imageURL = url
    }
}
