//
//  NetworkDataLoader.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// Protocol to help with network calls
protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

// Extension on URLSession so that it uses the protocol to do a URLSession.dataTask
extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
