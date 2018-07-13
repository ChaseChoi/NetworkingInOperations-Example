//
//  QuestionsRetrievalOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsRetrievalOperation: ConcurrentOperation<[Question]> {
    
    private let session: URLSession
    private let urlRequestFactory: QuestionsURLRequestFactory
    private var task: URLSessionTask?
    
    // MARK: - Init
    
    init(session: URLSession = URLSession.shared, urlRequestFactory: QuestionsURLRequestFactory = QuestionsURLRequestFactory()) {
        self.session = session
        self.urlRequestFactory = urlRequestFactory
    }
    
    // MARK: - Start
    
    override func start() {
        let urlRequest = urlRequestFactory.requestToRetrieveQuestions()
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    if let error = error {
                        self.complete(result: .failure(error))
                    } else {
                        self.complete(result: .failure(APIError.missingData))
                    }
                }
                return
            }
            
            do {
                let page = try JSONDecoder().decode(QuestionPage.self, from: data)
                
                DispatchQueue.main.async {
                    self.complete(result: .success(page.questions))
                }
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                    self.complete(result: .failure(APIError.serialization))
                }
            }
        }
        
        task?.resume()
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        super.cancel()
        task?.cancel()
        finish()
    }
}
