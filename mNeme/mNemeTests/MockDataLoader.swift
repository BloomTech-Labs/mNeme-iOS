//
//  MockDataLoader.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

@testable import mNeme

class ModckDataLoader {

    var data: Data?
    var error: Error?

    func loadData(using request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.error)
        }
    }
}
