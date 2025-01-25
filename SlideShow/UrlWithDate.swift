//
//  OldAndNewNames.swift
//  SlideShow
//
//  Created by Lenard Howell on 1/24/25.
//

import Foundation

struct UrlWithDate {
    let actualURL: URL
    var dateStr: String {
        extDates(actualURL)
    }
    
    func extDates(_ url: URL) -> String {
        let urlName = url.lastPathComponent
        var ext = ""
        let nameAndExtension = urlName.components(separatedBy: ".")
        if nameAndExtension.count > 1 {
            ext = nameAndExtension[1]
        }
        let onlyName = nameAndExtension[0]
        let components = onlyName.components(separatedBy: "-")
        if components.count != 5 { return urlName}
        var dateTimeComponent = components[3]
        let mon = dateTimeComponent.prefix(2)
        dateTimeComponent.removeFirst(2)
        let day = dateTimeComponent.prefix(2)
        dateTimeComponent.removeFirst(2)
        let year = dateTimeComponent.prefix(4)
        dateTimeComponent.removeFirst(4)
        var newName = "\(year)-\(mon)-\(day)-\(dateTimeComponent)"
        if ext.isEmpty == false { newName += ".\(ext)" }
        return newName
    }//func extDates


}

