import Foundation
import UIKit

class MainCustomListCell: UITableViewCell {

    let image = UIImageView()
    let nameLabel = UILabel()
    let starButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        addSubview(nameLabel)
        self.contentView.addSubview(starButton)
        
        nameLabel.textColor = .white
        nameLabel.backgroundColor = .black
        nameLabel.textAlignment = .center
        
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        
        starButton.tintColor = .blue
        
        image.anchor(top: topAnchor, left: leftAnchor, bottom: nameLabel.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 90, height: 0, enableInsets: false)
        nameLabel.anchor(top: image.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        starButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 50, height: 50, enableInsets: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
