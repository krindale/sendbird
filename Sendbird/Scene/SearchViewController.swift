//
//  SearchViewController.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // TableView for Searched Book List
    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.allowsSelection = true
        
        // Register TableView Cell
        tableView.register(BookCell.self,
                           forCellReuseIdentifier: BookCell.identifier)
        return tableView
    }()
    
    lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.viewController = self
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set UI
        self.setUI()
        // Setup For TableView Delegate / DataSource
        self.setupTableView()
    }
    
    private func setUI() {
        // Do any additional setup after loading the view.
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Books"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        // Set UI For TableView
        self.setTableViewUI()
        
        // Auto sizing row & cell height
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableView.automaticDimension
        self.definesPresentationContext = true
    }
    
    private func setTableViewUI() {
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Constraints for TableView
        self.tableView
            .centerXAnchor
            .constraint(equalTo:view.centerXAnchor)
            .isActive = true
        self.tableView
            .centerYAnchor
            .constraint(equalTo:view.centerYAnchor)
            .isActive = true
        self.tableView
            .heightAnchor
            .constraint(equalToConstant: self.view.frame.height)
            .isActive = true
        self.tableView
            .widthAnchor
            .constraint(equalToConstant: self.view.frame.width)
            .isActive = true
    }
    
    private func setupTableView() {
        // Set TableView Delegate / DataSource
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension SearchViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            // 키보드 닫기
            self.navigationItem.titleView?.endEditing(true)
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            if !self.viewModel.isPaging && self.viewModel.hasNextPage {
                self.viewModel.beginPaging()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search \(searchText)")
        // Fetch Search Book Result
        self.viewModel.fetchSearchResult(searchText: searchText)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Header - Total number of the searching book result
        return "Total - " + (self.viewModel.bookSearchResult?.total ?? "0")
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookSearchResult?.books.count ?? 0
    }
    

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            (self.viewModel.bookSearchResult?.books.count ?? 0) > indexPath.row,
            let bookCell = tableView
                            .dequeueReusableCell(withIdentifier: BookCell.identifier,
                                                 for: indexPath) as? BookCell
        else {
            return UITableViewCell()
        }
        
        // Book Cell 설정
        bookCell.bind(book: self.viewModel.bookSearchResult?.books[indexPath.row])
        
        return bookCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select 효과 없애기
        tableView.deselectRow(at: indexPath, animated: true)
        // 키보드 닫기
        self.view.endEditing(true)
        
        // Detail 화면 이동
        guard let cell = tableView.cellForRow(at: indexPath) as? BookCell,
              let isbn13 = cell.model?.isbn13 else { return }
        
        self.navigationController?
            .pushViewController(DetailViewController(isbn13: isbn13), animated: true)
    }
}
