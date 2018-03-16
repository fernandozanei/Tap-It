import UIKit

class FigureViewController: UIViewController {
    
	var gameManager:FigureGameManager?
	var topCard: UIImageView!
	var bottomCard: UIImageView!
    var first: PlayerScore!
    var second: PlayerScore!
    var third: PlayerScore!
	let imageSizeRatio = CGFloat(65.0 / 300.0)
	var imageSize:CGSize!
	var hasLayout = false
	var card:Card? {
		didSet {
			if self.hasLayout {
				self.setupCard(self.card!, isDeck: false)
			}
		}
	}
	var deckCard:Card? {
		didSet {
			if self.hasLayout {
				self.setupCard(self.deckCard!, isDeck: true)
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // BACKGROUND GRADIENT
        
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 250.0/255.0, green: 215.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 245.0/255.0, green: 125.0/255.0, blue: 55.0/255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // BOTTOM CARD
        
        bottomCard = UIImageView()
        bottomCard.image = UIImage(named: "card_3")
        bottomCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomCard)
        
        bottomCard.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 8).isActive = true
        bottomCard.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -8).isActive = true
        bottomCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        bottomCard.widthAnchor.constraint(equalTo: bottomCard.heightAnchor, constant: 0).isActive = true
        bottomCard.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        // top CARD
        
        topCard = UIImageView()
        topCard.image = UIImage(named: "card_3")
        topCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topCard)
        topCard.centerXAnchor.constraint(equalTo: bottomCard.centerXAnchor, constant: 0).isActive = true
        topCard.widthAnchor.constraint(equalTo: bottomCard.widthAnchor, multiplier: 0.8).isActive = true
        topCard.heightAnchor.constraint(equalTo: bottomCard.heightAnchor, multiplier: 0.8).isActive = true
        topCard.bottomAnchor.constraint(equalTo: bottomCard.topAnchor, constant: -16).isActive = true
        //topCard.
        
        if let objects = Bundle.main.loadNibNamed("PlayerScore", owner: self, options: nil), let scoreview = objects.first as? PlayerScore {
            first = scoreview
        }
        
        if let objects = Bundle.main.loadNibNamed("PlayerScore", owner: self, options: nil), let scoreview = objects.first as? PlayerScore {
            second = scoreview
        }
        
        if let objects = Bundle.main.loadNibNamed("PlayerScore", owner: self, options: nil), let scoreview = objects.first as? PlayerScore {
            third = scoreview
        }
        
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        //        stackview.spacing = 50.0
        stackview.addArrangedSubview(first)
        stackview.addArrangedSubview(second)
        stackview.addArrangedSubview(third)
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackview)
        
        stackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        stackview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        stackview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        stackview.bottomAnchor.constraint(equalTo: topCard.topAnchor, constant: -8).isActive = true
        stackview.heightAnchor.constraint(equalTo: bottomCard.heightAnchor, multiplier: 0.20).isActive = true
        
        gameManager!.delegate = self
		gameManager!.shouldStartGame()
    }
	
	override func viewDidLayoutSubviews() {
		if self.card != nil && self.hasLayout == false {
			self.setupCard(card!, isDeck: false)
		}
		if self.deckCard != nil && self.hasLayout == false {
			self.setupCard(deckCard!, isDeck: true)
		}
		self.hasLayout = true
	}
	
	private func setupCard(_ card: Card, isDeck: Bool) {
		if !isDeck {
			let frame = self.bottomCard.frame
			self.imageSize = CGSize(width: frame.width * self.imageSizeRatio, height: frame.height * self.imageSizeRatio)
			let centerPoint = CGPoint(x: frame.width / CGFloat(2), y: frame.height / CGFloat(2))
			let images = self.getImages(center: centerPoint, card: card, containerWidth: frame.width)
			for image in images {
				self.bottomCard.addSubview(image)
			}
		} else {
			let frame = self.topCard.frame
			self.imageSize = CGSize(width: frame.width * self.imageSizeRatio, height: frame.height * self.imageSizeRatio)
			let centerPoint = CGPoint(x: frame.width / CGFloat(2), y: frame.height / CGFloat(2))
			let images = self.getImages(center: centerPoint, card: card, containerWidth: frame.width)
			for image in images {
				self.topCard.addSubview(image)
			}
		}
	}
	
	private func getImages(center:CGPoint, card: Card, containerWidth: CGFloat) -> [UIImageView] {
		var images = [UIImageView]()
		var counter = 0
		let image_1 = self.getImage(center: center, number: card.face[counter].imageNumber, rotation: card.face[counter].rotation)
		images.append(image_1)
		counter += 1
		let distFromMax = CGFloat(1)
		var rad = CGFloat(card.rotation)
		let radAdder = (2 * CGFloat.pi) / CGFloat(card.face.count - 1)
		let maxLenght = (containerWidth / 2) - (imageSize.width / 1.3)
		while (card.face.count > counter) {
			let x = center.x + (maxLenght * distFromMax) * cos(rad)
			let y = center.y + (maxLenght * distFromMax) * sin(rad)
			let point = CGPoint(x: x, y: y)
			let image = self.getImage(center: point, number: card.face[counter].imageNumber, rotation: card.face[counter].rotation)
			images.append(image)
			counter += 1
			rad += radAdder
		}
		return images
	}
	
	private func getImage(center:CGPoint, number:Int, rotation:CGFloat) -> UIImageView {
		let imageOrigin = CGPoint(x: center.x - (imageSize.width / 2), y: center.y - (imageSize.height / 2))
		let imageRect = CGRect(origin: imageOrigin, size: imageSize)
		let image = UIImageView(frame: imageRect)
		let name = "figure_\(number)"
		image.image = UIImage(named: name)
		image.contentMode = .scaleAspectFit
		image.transform = CGAffineTransform(rotationAngle: rotation)
		return image
	}
	
}

extension FigureViewController : FigureProtocol {
	
	func updatePlayerCard(_ card: Card) {
		DispatchQueue.main.async {
			self.card = card
		}
	}
	
    func updateDeck(_ card: Card) {
        DispatchQueue.main.async {
			self.deckCard = card
        }
    }
}

extension FigureViewController : CardViewProtocol {
    func getTapped(figureNumber: Int) {
        gameManager?.checkAnswer(figureNumber)
    }
}
