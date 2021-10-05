//
//  BookCell.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import UIKit

final class BookCell: UITableViewCell {

    static let identifier: String = "BookCell"
    
    // Image Logo Image
    lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // StackView for All UILabels
    lazy var labelStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var titleLbl = UILabel(number: 0)
    var subtitleLbl = UILabel(number: 0)
    var isbn13Lbl = UILabel(number: 0)
    var priceLbl = UILabel(number: 0)
    var urlLbl = UILabel(number: 0)
    
    var model: Book? {
        didSet {
            self.updateUI(model: self.model)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // ImageView Constraints
    private func imageViewConstraints(imageView: UIImageView) {
        
        // Add ImageView Constraints
        imageView
            .leftAnchor
            .constraint(equalTo: self.contentView.leftAnchor, constant: 20.0)
            .isActive = true
        
        imageView
            .topAnchor
            .constraint(equalTo: self.contentView.topAnchor, constant: 20.0)
            .isActive = true
        
        imageView
            .widthAnchor
            .constraint(equalToConstant: 75.0)
            .isActive = true
        
        imageView
            .heightAnchor
            .constraint(equalToConstant: 100.0)
            .isActive = true

    }
    
    // Label Constraints
    private func labelsConstraints(stackView: UIStackView) {
        
        // Add Constraints
        stackView
            .leftAnchor
            .constraint(equalTo: self.contentView.leftAnchor, constant: 100.0)
            .isActive = true
        stackView
            .rightAnchor
            .constraint(equalTo: self.contentView.rightAnchor, constant: -20.0)
            .isActive = true
        stackView
            .topAnchor
            .constraint(equalTo: self.contentView.topAnchor, constant: 20.0)
            .isActive = true
        stackView
            .bottomAnchor
            .constraint(equalTo: self.contentView.bottomAnchor, constant: -20.0)
            .isActive = true
    }

    // Init Cell UI
    private func setUI() {
        // Image View
        self.contentView.addSubview(self.bookImageView)
        self.imageViewConstraints(imageView: self.bookImageView)
        
        // Label Stack View
        self.contentView.addSubview(self.labelStackView)
        self.labelsConstraints(stackView: self.labelStackView)
        
        // Add Subviews
        self.labelStackView.addArrangedSubview(self.titleLbl)
        self.labelStackView.addArrangedSubview(self.subtitleLbl)
        self.labelStackView.addArrangedSubview(self.isbn13Lbl)
        self.labelStackView.addArrangedSubview(self.priceLbl)
        self.labelStackView.addArrangedSubview(self.urlLbl)
    }
    
    private func updateUI(model: Book?) {
        guard let model = model else { return }
        
        // Book Cell Text Set
        self.titleLbl.text = model.title
        self.subtitleLbl.text = model.subtitle
        self.isbn13Lbl.text = model.isbn13
        self.priceLbl.text = model.price
        self.urlLbl.text = model.url
        
        // Get Image From URL or Cache
        if let cachedImage = ImageCache.shared.getImage(isbn13: model.isbn13) {
            self.imageFromCache(image: cachedImage)
        } else {
            self.bookImageView.imageFromUrl(isbn13: model.isbn13, url: model.image)
        }
    }
    
    // Get Image From Image Caches
    private func imageFromCache(image: UIImage) {
        DispatchQueue.main.async {
            self.bookImageView.image = image
            self.bookImageView.contentMode = .scaleAspectFit
        }
    }
    
    // Bind Model
    func bind(book: Book?) {
        self.model = book
    }
}
