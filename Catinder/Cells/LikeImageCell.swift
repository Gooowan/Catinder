import UIKit
import SnapKit


class LikedImageCell: UITableViewCell {

    let likedImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(likedImageView)
        setupLayout()
        
    }
    
    func setupLayout() {
        likedImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(350)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
