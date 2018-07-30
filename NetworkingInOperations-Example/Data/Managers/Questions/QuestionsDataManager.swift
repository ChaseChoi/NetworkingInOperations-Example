//
//  QuestionsDataManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsDataManager {
    
    private let queueManager: QueueManager
    
    // MARK: - Init
    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Retrieval
    
    func retrievalQuestions(completionHandler: @escaping (_ result: DataRequestResult<[Question]>) -> Void) {
        let operation = QuestionsRetrievalOperation()
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
    
}
