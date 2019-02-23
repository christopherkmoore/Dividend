//
//  CodableSerialization.swift
//  Dividend
//
//  Created by Christopher Moore on 2/22/19.
//  Copyright © 2019 Christopher Moore. All rights reserved.
//

import Foundation


class CodableSerialization {
    
    public static func create<T: Decodable>(from data: Data) throws -> T {
        let thing: T
        
        do {
            thing = try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            throw error
            
        }
        return thing
    }
}
