import UIKit
import Combine

class CatBreedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let catAPIService = CatAPIService()
    private var breeds: [Breed] = []
    private var breedImages: [String: UIImage] = [:]
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cat Breeds"
        view.backgroundColor = .white

        loadBreedsAndImages()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BreedCell.self, forCellReuseIdentifier: BreedCell.identifier)
        tableView.rowHeight = 120
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func loadBreedsAndImages() {
        catAPIService.fetchCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to load breeds: \(error)")
                }
            }, receiveValue: { [weak self] breeds in
                self?.breeds = breeds
                self?.fetchImagesForBreeds()
            })
            .store(in: &cancellables)
    }

    private func fetchImagesForBreeds() {
        let publishers = breeds.map { breed in
            catAPIService.fetchCats(limit: 1, format: "jpg", breedID: breed.id)
                .compactMap { $0.first?.url }
                .flatMap { urlString -> AnyPublisher<UIImage?, Never> in
                    guard let url = URL(string: urlString) else {
                        return Just(nil).eraseToAnyPublisher()
                    }
                    return self.catAPIService.fetchImage(at: url)
                        .catch { _ in Just(nil) }
                        .eraseToAnyPublisher()
                }
                .map { image in (breed.id, image) }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if self == nil { return }
                
                if case .failure(let error) = completion {
                    print("Failed to load some breed images: \(error)")
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                for (breedID, image) in results {
                    if let image = image {
                        self.breedImages[breedID] = image
                    }
                }
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedCell.identifier, for: indexPath) as? BreedCell else {
            return UITableViewCell()
        }
        
        let breed = breeds[indexPath.row]
        let breedImage = breedImages[breed.id]
        cell.configure(with: breed, image: breedImage)
        
        return cell
    }
}
