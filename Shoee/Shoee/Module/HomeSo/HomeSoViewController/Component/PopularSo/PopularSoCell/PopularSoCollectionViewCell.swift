import UIKit

class PopularSoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var titleCategoryProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeCornerRadius(15)
    }

    func configure(name: String?, price: String?, imageURL: String?, category: String?) {
        productName.text = name
        priceText.text = price
        titleCategoryProduct.text = category

        if let url = URL(string: imageURL ?? "") {
            popularImage.kf.setImage(with: url)
        } else {
            popularImage.image = nil
        }
    }
}
