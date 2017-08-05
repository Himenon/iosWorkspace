//: Playground - noun: a place where people can play

import Cocoa

enum IPTCmeta: String {
    case CopyrightNotice
    case DateCreated
    case TimeCreated
}

var IPTC: [IPTCmeta: Bool] = [
    .CopyrightNotice: false,
    .DateCreated: false,
    .TimeCreated: false
]

//for (key, val) in IPTC {
//    print(key)
//    print(val)
//}

let kkey = IPTCmeta(rawValue: "CopyrightNotice")

IPTC.updateValue(true, forKey: IPTCmeta(rawValue: "CopyrightNotice")!)

IPTC
