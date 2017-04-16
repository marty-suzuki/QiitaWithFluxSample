//
//  Date.ISO8601.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

extension Date {
    private static let ISO8601Formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return dateFormatter
    }()
    
    
    init?(ISO8601String string: String) {
        guard let date = Date.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
}
