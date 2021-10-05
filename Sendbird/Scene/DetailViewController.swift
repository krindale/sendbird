//
//  DetailViewController.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/30.
//

import UIKit

class DetailViewController: UIViewController {

    private var viewModel: DetailViewModel
    
    // 전체 Scroll View
    private let scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // StackView for Book Details
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // Book Title Labels
    var titleLbl = UILabel(number: 0)
    
    // Book Image
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Book Detail Labels
    var subtitileLbl = UILabel(number: 0)
    var authorsLbl = UILabel()
    var publisherLbl = UILabel()
    var languageLbl = UILabel()
    var isbn10Lbl = UILabel()
    var isbn13Lbl = UILabel()
    var pagesLbl = UILabel()
    var yearLbl = UILabel()
    var ratingLbl = UILabel()
    var descLbl = UILabel(number: 0)
    var priceLbl = UILabel()
    var urlLbl = UILabel(number: 0)
    var noteLbl = UILabel(number: 0)
    
    init(isbn13: String) {
        self.viewModel = DetailViewModel(isbn13: isbn13)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI()
        self.viewModel.fetchBookDetail()
    }
    
    private func setUI() {
        
        // Add Note Button in Navigation Bar
        self.navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: "Add Note",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addNote))
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        // Add Detail Labels to StackView
        self.stackView.addArrangedSubview(self.titleLbl)
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.subtitileLbl)
        self.stackView.addArrangedSubview(self.authorsLbl)
        self.stackView.addArrangedSubview(self.publisherLbl)
        self.stackView.addArrangedSubview(self.languageLbl)
        self.stackView.addArrangedSubview(self.isbn10Lbl)
        self.stackView.addArrangedSubview(self.isbn13Lbl)
        self.stackView.addArrangedSubview(self.yearLbl)
        self.stackView.addArrangedSubview(self.ratingLbl)
        self.stackView.addArrangedSubview(self.descLbl)
        self.stackView.addArrangedSubview(self.priceLbl)
        self.stackView.addArrangedSubview(self.urlLbl)
        self.stackView.addArrangedSubview(self.noteLbl)
        
        
        // ScrollView Constraints
        self.scrollView
            .leadingAnchor
            .constraint(equalTo:view.leadingAnchor)
            .isActive = true
        self.scrollView
            .trailingAnchor
            .constraint(equalTo:view.trailingAnchor)
            .isActive = true
        self.scrollView
            .topAnchor
            .constraint(equalTo:self.view.topAnchor)
            .isActive = true
        self.scrollView
            .bottomAnchor
            .constraint(equalTo:self.view.bottomAnchor)
            .isActive = true
        
        // StackView Constraints
        self.stackView
            .widthAnchor
            .constraint(equalTo:self.scrollView.widthAnchor)
            .isActive = true
        self.stackView
            .topAnchor
            .constraint(equalTo:self.scrollView.topAnchor)
            .isActive = true
        self.stackView
            .bottomAnchor
            .constraint(equalTo:self.scrollView.bottomAnchor)
            .isActive = true
        
        // Tap gesture recognizers
        let webLinkTap = UITapGestureRecognizer(target: self, action: #selector(self.webLink))

        // Gesture recognizer Label
        self.urlLbl.isUserInteractionEnabled = true
        self.urlLbl.addGestureRecognizer(webLinkTap)
    }
    
    @objc
    private func webLink() {
        if let url = URL(string: self.viewModel.model?.url ?? "") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc
    private func addNote() {
        let alert = UIAlertController(title: "Note", message: "Add a Note", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add Note"
        }
        alert.addAction(UIAlertAction(title: "OK", style:
                                        .default,
                                      handler: { [weak self, weak alert] (_) in
            let textField = alert?.textFields?[0] // Force unwrapping because we know it exists.
                                        
            guard let model = self?.viewModel.model,
                  let text = textField?.text else { return }
            // Store Note
            NoteManager.shared.store(isbn13: model.isbn13, note: text)
            // Update Note
            self?.noteLbl.text = "Note : "
                + (NoteManager.shared.getNote(isbn13: model.isbn13) ?? "(Empty)")
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension NSMutableAttributedString {

    func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
