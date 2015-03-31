// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble


func equalToDay(expectedValue: NSDate) -> NonNilMatcherFunc<NSDate> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal to day <\(expectedValue)>"

        if let actualValue = actualExpression.evaluate() {
            failureMessage.actualValue = "<\(actualValue)>"

            let calendar = NSCalendar.currentCalendar()
            let actualComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: actualValue)
            let expectedComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: expectedValue)

            return actualComponents.year == expectedComponents.year && actualComponents.month == expectedComponents.month && actualComponents.day == expectedComponents.day
        } else {
            failureMessage.actualValue = "<nil>"
            return false
        }
    }
}

