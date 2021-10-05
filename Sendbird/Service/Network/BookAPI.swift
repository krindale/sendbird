//
//  Network.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import Foundation
import UIKit

enum BookAPI {
    static private let baseURL = "https://api.itbook.store/1.0/"
    
    case searchBooks(searchText: String, paging: Int)
    case bookDetail(isbn13: String)
    
    var url: String {
        switch self {
        case .searchBooks(let searchText, let paging):
            return BookAPI.baseURL + "search/\(searchText)/\(paging)"
        case .bookDetail(let isbn13):
            return BookAPI.baseURL + "books/\(isbn13)"
        }
    }
}

final class BookAPIProvider {

    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBooks(searchText: String, paging: Int , completion: @escaping (Result<BookSearchModel, Error>) -> Void) {
        
        // Check Cache
        if let response = SearchCaches.shared
            .getResponse(key: SearchCacheKey(searchText: searchText, page: paging)) {
            completion(.success(response))
        } else {
            self.requestSearchBook(searchText: searchText, paging: paging,
                                   completion: completion )
        }
    }
    
    private func requestSearchBook(searchText: String, paging: Int ,
                                   completion: @escaping (Result<BookSearchModel, Error>)
                                    -> Void) {
        
            guard let url = URL(string: BookAPI.searchBooks(searchText: searchText, paging: paging).url) else { return }
            let request = URLRequest(url: url)
            
            let task: URLSessionDataTask = session
                .dataTask(with: request) { [weak self] data, urlResponse, error in
                    guard let response = urlResponse as? HTTPURLResponse,
                          (200...399).contains(response.statusCode) else {
                        // Error
                        //                    completion(.failure(error))
                        self?.errorPopup(error: error)
                        return
                    }
                    
                    if let data = data,
                       let response = try? JSONDecoder().decode(BookSearchModel.self, from: data) {
                        SearchCaches.shared
                            .store(key: SearchCacheKey(searchText: searchText, page: paging),
                                   model: response)
                        completion(.success(response))
                        return
                    }
                    // Error
                    //                completion(.failure(.error))
                    self?.errorPopup(error: error)
                }
            
            task.resume()
    }
    
    func fetchBookDetail(isbn13: String, completion: @escaping (Result<BoolDetailModel, Error>) -> Void) {
        guard let url = URL(string: BookAPI.bookDetail(isbn13: isbn13).url) else { return }
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { [weak self ]data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...399).contains(response.statusCode) else {
                    // Error
//                    completion(.failure(error))
                    self?.errorPopup(error: error)
                    return
                }
                
                if let data = data,
                   let response = try? JSONDecoder().decode(BoolDetailModel.self, from: data) {
                    completion(.success(response))
                    return
                }
                // Error
//                completion(.failure(.error))
                self?.errorPopup(error: error)
            }
        
        task.resume()
    }
    
    // Network Error Popup
    private func errorPopup(error: Error?) {
        let alert = UIAlertController(title: "알림", message: error?.localizedDescription ?? "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        UIApplication.shared.topViewController?.present(alert, animated: false)
    }
}

