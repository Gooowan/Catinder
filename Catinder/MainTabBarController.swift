import UIKit

class MainTabBarController: UITabBarController {
    
    private var likedImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let likedImagesVC = LikedViewController()
        let catFinderVC = CatFinderViewController()
        let catBreedsVC = CatBreedsViewController()
        
        catFinderVC.likedImages = likedImagesVC
        
        catFinderVC.tabBarItem = UITabBarItem(title: "Rate Cats", image: UIImage(systemName: "pawprint"), tag: 0)
        catBreedsVC.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "list.bullet"), tag: 1)
        likedImagesVC.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart"), tag: 2)
        
        viewControllers = [catFinderVC, catBreedsVC, likedImagesVC]
    }
}
