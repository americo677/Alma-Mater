//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var date1 = Date()
var date3 = Date()
var date = NSDate()
var date2 = NSDate()

let dtFormatter = DateFormatter()

dtFormatter.dateFormat = "yyyy-MM-dd"

print("date: \(date) NSDate: \(date1)")

print(date.description)

date = dtFormatter.date(from: "2017-03-15")! as NSDate

date1 = dtFormatter.date(from: "2017-03-15")!

if date.compare(date1) == .orderedSame {
    print("Son iguales las fechas")
} else {
    print("No son iguales las fechas")
}

print("\(date.compare(date1) != ComparisonResult.orderedSame)")

date2 = dtFormatter.date(from: "2017-03-15")! as NSDate

if date.compare(date2 as Date) == .orderedSame {
    print("Son iguales las fechas")
} else {
    print("No son iguales las fechas")
}

if date1 == date3 {
    print("Son iguales las fechas")
} else {
    print("No son iguales las fechas")
}

//let num = NSUUID()

let uuid = UUID().uuidString
print(uuid)

