//
//  DateFormatter+Extension.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation

public extension DateFormatter {
    
    static var comicDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-ZZZZ"
        return df
    }
}
