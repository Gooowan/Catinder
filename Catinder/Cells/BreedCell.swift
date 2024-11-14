import UIKit
import SnapKit

class BreedCell: UITableViewCell {
    
    static let identifier = "BreedCell"

    private let breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(breedImageView)
        contentView.addSubview(breedLabel)

        breedImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(breedImageView.snp.width)
        }

        breedLabel.snp.makeConstraints { make in
            make.leading.equalTo(breedImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with breed: Breed, image: UIImage?) {
        breedLabel.text = breed.name
        breedImageView.image = image
    }
}
