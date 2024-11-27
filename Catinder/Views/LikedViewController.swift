import UIKit

class LikedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    var likedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Liked Images"
        view.backgroundColor = .white

        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikedImageCell.self, forCellReuseIdentifier: "LikedImageCell")
        tableView.rowHeight = 420

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func addLikedImage(_ image: UIImage) {
        likedImages.append(image)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikedImageCell", for: indexPath) as? LikedImageCell else {
            return UITableViewCell()
        }
        
        cell.likedImageView.image = likedImages[indexPath.row]
        return cell
    }
}
