import UIKit

class FigureViewController: UIViewController {
    
//    let gameManager = FigureGameManager()
	var gameManager:FigureGameManager?
//	let gameManager = FigureGameManager(playerName: "test")
	var deckView: CardView!
	var cardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		if let objects = Bundle.main.loadNibNamed("CardView", owner: self, options: nil), let deckview = objects.first as? CardView {
			self.deckView = deckview
            self.deckView.delegate = self
		}
        
		if let objects = Bundle.main.loadNibNamed("CardView", owner: self, options: nil), let cardview = objects.first as? CardView {
			self.cardView = cardview
            self.cardView.delegate = self
        }
        
        let vertStack = UIStackView()
		vertStack.axis = .vertical
		vertStack.distribution = .equalSpacing
		vertStack.spacing = 100.0
		vertStack.backgroundColor = .black
		vertStack.addArrangedSubview(self.deckView)
		vertStack.addArrangedSubview(self.cardView)
		self.view.addSubview(vertStack)
		vertStack.backgroundColor = .black
		vertStack.translatesAutoresizingMaskIntoConstraints = false
		vertStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32.0).isActive = true
		vertStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
		vertStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        gameManager!.delegate = self
		gameManager!.shouldStartGame()
    }
	
}

extension FigureViewController : FigureProtocol {
	
	func updatePlayerCard(_ card: Card) {
		DispatchQueue.main.async {
			self.cardView.setupFigures(figures: card.face)
		}
	}
	
    func updateDeck(_ card: Card) {
        DispatchQueue.main.async {
			self.deckView.setupFigures(figures: card.face)
        }
    }
}

extension FigureViewController : CardViewProtocol {
    func getTapped(figureNumber: Int) {
//        gameManager.
    }
}