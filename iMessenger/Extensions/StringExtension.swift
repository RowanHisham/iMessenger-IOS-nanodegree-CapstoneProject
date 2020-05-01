//
//  StringExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/30/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation

extension String
{
    func toDate(dateFormat format : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.date(from: self)!
    }
}
