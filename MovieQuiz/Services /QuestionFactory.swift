import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private var isLoading = false
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        guard !isLoading else { return }
        
        isLoading = true
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                    
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else {
            loadData()
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let movie = self.movies.randomElement() else {
                DispatchQueue.main.async {
                    self.loadData()
                }
                return
            }
            
            self.loadImageData(for: movie) { imageData in
                let rating = Float(movie.rating) ?? 0
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                
                let question = QuizQuestion(
                    image: imageData,
                    text: text,
                    correctAnswer: correctAnswer
                )
                
                DispatchQueue.main.async {
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
        }
    }
    
    private func loadImageData(for movie: MostPopularMovie, completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL, options: .alwaysMapped)
            } catch {
                print("Failed to load image for movie: \(movie.title), error: \(error.localizedDescription)")
            }
            
            completion(imageData)
        }
    }
}
