//
//  BreakingBadQuote.swift
//  DecAR
//
//  Created by iosdev on 7.12.2022.
//

import Foundation

struct Quote: Codable {
    let quote: String
    let author: String
}

func getQuote(quoteCompletionHandler: @escaping (Quote?, Error?) -> Void) {
    guard let apiUrl = URL(string: "https://api.breakingbadquotes.xyz/v1/quotes") else {
        fatalError("Failed to create api URL")
    }
    
    let task = URLSession.shared.dataTask(with: apiUrl, completionHandler: { data, response, error in
        
        if let error = error {
            print("Client error \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            return
        }
        
        guard let data = data else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let quoteData = try decoder.decode([Quote].self, from: data)
            
            quoteCompletionHandler(quoteData[0], nil)
        } catch let error {
            print("parse error \(error)")
            quoteCompletionHandler(nil, error)
        }
    })
    task.resume()
}
