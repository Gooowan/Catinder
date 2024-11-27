import UIKit
import SnapKit
import Combine

class CatFinderViewController: UIViewController {
    
    var likedImages: LikedViewController?
    var spinnerView = SpinnerView()
    var catAPIService = CatAPIService()
    var cancellables = Set<AnyCancellable>()
    
    let catImageView: UIImageView = {
        let catImageView = UIImageView()
        catImageView.contentMode = .scaleAspectFill
        catImageView.layer.cornerRadius = 15
        catImageView.clipsToBounds = true
        catImageView.layer.shadowColor = UIColor.black.cgColor
        catImageView.layer.shadowOpacity = 0.15
        catImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        catImageView.layer.shadowRadius = 8
        catImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        catImageView.isHidden = true
        return catImageView
    }()
    
    private let likeButton: UIButton = {
        
        let likeButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
        likeButton.tintColor = .green
        likeButton.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        likeButton.layer.cornerRadius = 100
        return likeButton
    }()
    
    private let dislikeButton: UIButton = {
        
        let dislikeButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        
        dislikeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration), for: .normal)
        dislikeButton.tintColor = .red
        dislikeButton.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        dislikeButton.layer.cornerRadius = 100
        
        return dislikeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Rate Cats"
        
        view.addSubview(spinnerView)
        view.addSubview(catImageView)
        view.addSubview(likeButton)
        view.addSubview(dislikeButton)
        
        setupLayout()
        
        setupSwipeGestures()
        loadNewCatImage()
    }

    private func setupLayout() {
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        catImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.width.equalTo(view.snp.width).multipliedBy(0.85)
            $0.height.equalTo(catImageView.snp.width).multipliedBy(0.6)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(view.snp.centerX).offset(-40)
            $0.bottom.equalToSuperview().inset(200)
            $0.width.height.equalTo(200)
        }
        
        dislikeButton.snp.makeConstraints {
            $0.leading.equalTo(view.snp.centerX).offset(40)
            $0.bottom.equalToSuperview().inset(200)
            $0.width.height.equalTo(200)
        }
    }

    private func setupSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        catImageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        catImageView.addGestureRecognizer(swipeLeft)
        
        catImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSwipeLeft() {
        
        print("Cat liked!")
        if let image = catImageView.image { likedImages?.addLikedImage(image) }
        animateSwipe(direction: .left)
    }
        
    @objc func handleSwipeRight() {
        print("Cat disliked!")
        animateSwipe(direction: .right)
    }

    private func animateSwipe(direction: UISwipeGestureRecognizer.Direction) {
        let translationX: CGFloat = direction == .right ? view.bounds.width : -view.bounds.width
        let rotationAngle: CGFloat = .pi / 4
        let scale: CGFloat = 4

        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.catImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
                .scaledBy(x: scale, y: scale)
                .translatedBy(x: translationX, y: 0)
        }) { _ in
            
            self.catImageView.transform = .identity
            self.loadNewCatImage()
        }
    }
    
    
    // mainly same as in tests
    func loadNewCatImage() {
        spinnerView.isHidden = false
        catImageView.isHidden = true

        catAPIService.fetchCats(limit: 1, format: "jpg", breedID: nil)
            .flatMap { cats -> AnyPublisher<UIImage?, Error> in
                guard let urlString = cats.first?.url, let url = URL(string: urlString) else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.catAPIService.fetchImage(at: url)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch cat image: \(error)")
                }
                self.spinnerView.isHidden = true
            }, receiveValue: { [weak self] image in
                self?.catImageView.isHidden = false
                self?.catImageView.image = image
            })
            .store(in: &cancellables)
    }
    
}
