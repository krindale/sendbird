//
//  SearchViewModel.swift
//  Sendbird
//
//  Created by 이해상 on 2021/10/04.
//

import Foundation

final class SearchViewModel {
    // Search View Controller
    var viewController: SearchViewController?
    
    // Search Text / Page
    private var currentSearchingText: String = ""
    private var currentResultPage: Int = 1
    
    // For Searching Paging
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    
    // Search Result
    var bookSearchResult: BookSearchModel? {
        didSet {
            // Reload TableView when Search Result Updated
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.tableView.reloadData()
            }
        }
    }
    
    private func resetSearchRequest() {
        // Reset Search Request
        self.currentSearchingText = ""
        self.currentResultPage = 1
        self.bookSearchResult = BookSearchModel(total: "", page: "", books: [])
    }
    
    
    func beginPaging() {
        
        self.isPaging = true // 현재 페이징이 진행 되는 것을 표시
        self.currentResultPage += 1
        
        // Searching Book Next Page
        BookAPIProvider()
            .searchBooks(searchText: self.currentSearchingText,
                         paging: self.currentResultPage) { [weak self] response in
            guard let model = try? response.get() as BookSearchModel else { return }
            
            self?.bookSearchResult?.books.append(contentsOf: model.books)
            self?.hasNextPage = (Int(model.total) ?? 0) / 10 > Int(model.page) ?? 0
            self?.isPaging = false
        }
    }
    
    func fetchSearchResult(searchText: String) {
        
        self.resetSearchRequest()
        
        if searchText.isEmpty {
            return
        }
        
        // Search Book Api Call
        BookAPIProvider()
            .searchBooks(searchText: searchText, paging: 1) { [weak self] response in
            guard let model = try? response.get() as BookSearchModel else { return }
            self?.currentSearchingText = searchText
            self?.bookSearchResult = model
            self?.hasNextPage = (Int(model.total) ?? 0) / 10 >= Int(model.page) ?? 0
            self?.isPaging = false
        }
    }
}
