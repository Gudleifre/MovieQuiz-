import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func toggleButtons(isEnabled: Bool)
    func hideImageBorder()
    func showContentView()
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func showNetworkError(message: String)
}
