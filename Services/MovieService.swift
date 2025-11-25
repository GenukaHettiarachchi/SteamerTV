import Foundation
import Combine

class MovieService: ObservableObject {
    @Published var movies: [Movie] = []
    
    static let shared = MovieService()
    
    private init() {
        print("🎬 MovieService: Initializing...")
        loadLocal()
    }
    
    func loadLocal() {
        // 1. Check if file exists in Bundle
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("❌ ERROR: Could not find 'movies.json' in the Bundle.")
            print("   -> ACTION: Check 'Target Membership' in the right sidebar of Xcode.")
            return
        }
        
        print("✅ FOUND: movies.json at \(url)")

        do {
            // 2. Try to load data
            let data = try Data(contentsOf: url)
            print("✅ LOADED: \(data.count) bytes of data")
            
            // 3. Try to decode
            let decodedMovies = try JSONDecoder().decode([Movie].self, from: data)
            
            DispatchQueue.main.async {
                self.movies = decodedMovies
                print("✅ SUCCESS: Decoded \(self.movies.count) movies.")
            }
            
        } catch let DecodingError.dataCorrupted(context) {
            print("❌ JSON ERROR: Data corrupted - \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ JSON ERROR: Key '\(key)' not found - \(context.debugDescription)")
            print("   -> Check if your JSON keys match your Swift Struct exactly.")
        } catch let DecodingError.valueNotFound(value, context) {
            print("❌ JSON ERROR: Value '\(value)' not found - \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ JSON ERROR: Type mismatch - \(type) - \(context.debugDescription)")
            print("   -> Example: Did you put a String in the JSON where Swift expects an Int?")
        } catch {
            print("❌ GENERIC ERROR: \(error)")
        }
    }
}
