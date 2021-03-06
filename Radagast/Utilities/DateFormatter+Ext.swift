//
//  DateFormatter+Ext.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation

extension DateFormatter {
    
    // Coding Date Formatters
    ///Defaults to ISO8601 date format used by the API of our choosing
    static let carbon: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd'T'hh:mm'Z'"
        return df
    }()
    
    static let standard: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "YYYY-MM-DD"
        return df
    }()
    
    static let viewReady: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .medium
        return df
    }()
}
