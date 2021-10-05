//
//  DetailViewModel.swift
//  Sendbird
//
//  Created by 이해상 on 2021/10/04.
//

import Foundation

final class DetailViewModel {
    // Detail View Controller
    var viewController: DetailViewController?
    
    private var isbn13: String
    var model: BoolDetailModel?
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
    
    // Fetch Book Details
    func fetchBookDetail() {
        
        BookAPIProvider().fetchBookDetail(isbn13: self.isbn13) { [weak self] response in
            guard let model = try? response.get() as BoolDetailModel else { return }
            print (model)
            self?.model = model
            
            DispatchQueue.main.async { [weak self] in
                // Set Labels Text
                self?.viewController?.titleLbl.text = "Title : " + model.title
                // Get Image From URL or Cache
                if let cachedImage = ImageCache.shared.getImage(isbn13: model.isbn13) {
                    self?.viewController?.imageView.image = cachedImage
                } else {
                    self?.viewController?.imageView.imageFromUrl(isbn13: model.isbn13, url: model.image)
                }
                self?.viewController?.subtitileLbl.text = "Subtitle : " + model.subtitle
                self?.viewController?.authorsLbl.text = "Authors : " + model.authors
                self?.viewController?.publisherLbl.text = "Publisher : " + model.publisher
                self?.viewController?.languageLbl.text = "Language : " + model.language
                self?.viewController?.isbn10Lbl.text = "isbn10 : " + model.isbn10
                self?.viewController?.isbn13Lbl.text = "isbn13 : " + model.isbn13
                self?.viewController?.pagesLbl.text = "Pages : " + model.pages
                self?.viewController?.yearLbl.text = "Year : " + model.year
                self?.viewController?.ratingLbl.text = "Rating : " + model.rating
                self?.viewController?.descLbl.text = "Description : " + model.desc
                self?.viewController?.priceLbl.text = "Price : " + model.price

                // Add Web Link
                let attributedString = NSMutableAttributedString(string: "URL : " + model.url)
                let _ = attributedString.setAsLink(textToFind: model.url, linkURL: model.url)
                self?.viewController?.urlLbl.attributedText = attributedString
                
                // Note Label
                self?.viewController?.noteLbl.text = "Note : " + (NoteManager.shared.getNote(isbn13: model.isbn13) ?? "(Empty)")
            }
        }
    }
}
