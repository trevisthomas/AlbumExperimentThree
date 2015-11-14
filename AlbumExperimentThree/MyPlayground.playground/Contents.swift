//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let radius = 60.0
var bc = sqrt((pow(radius, 2.0)) / 2.0)

let l = 100.0
let v = pow(l, 2)

func exponentialLove(value : CGFloat) -> CGFloat {
    //The assumption is that 'value' is a number between 0 and
    let scallingFactor : CGFloat = 100
    let exponent : CGFloat = 2.0
    let scaledX = scallingFactor * value //Now i have a number between 0 and 100
    let tempY = pow (scaledX, exponent) //Now i have a number between 0 and 10000
    let exponentialY = tempY / pow (scallingFactor, exponent)
    return exponentialY
}

var linear : [CGFloat] = []
var exp : [CGFloat] = []
for i in 0...10 {
    var j = CGFloat(i) / 10.0
    
    linear.append(j)
    exp.append(exponentialLove(j))
}

print(linear)
print(exp)





