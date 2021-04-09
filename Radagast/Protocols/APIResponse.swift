//
//  APIResponse.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

protocol APIResponse: Decodable {
    func validate() -> Bool
}
