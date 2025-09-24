import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Structs
    struct Fonts {
        static let ysDisplayMediumFontName = "YSDisplay-Medium"
        static let ysDisplayMedium20 = UIFont(name: ysDisplayMediumFontName, size: 20)
        
        static let ysDisplayBoldFontName = "YSDisplay-Bold"
        static let ysDisplayBold23 = UIFont(name: ysDisplayBoldFontName, size: 23)
    }
    
    // MARK: - IB Outlets
    @IBOutlet private weak var contentView: UIStackView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter?
    private var alertPresenter = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewController = self
        presenter = MovieQuizPresenter(viewController: self)
        
        activityIndicator.hidesWhenStopped = true
        contentView.isHidden = true
        showLoadingIndicator()
        
        // шрифт и размер текста у элементов:
        textLabel.font = Fonts.ysDisplayBold23
        counterLabel.font = Fonts.ysDisplayMedium20
        noButton.titleLabel?.font = Fonts.ysDisplayMedium20
        yesButton.titleLabel?.font = Fonts.ysDisplayMedium20
        // скругления:
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    // MARK: - Public Methods
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func toggleButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func hideImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func showContentView() {
        contentView.isHidden = false
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title,
                               message: result.text,
                               buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorModel = AlertModel(title: "Что-то пошло не так(",
                                    message: message,
                                    buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
        }
        
        alertPresenter.show(in: self, model: errorModel)
    }
}
