// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class ChainedTextField: UITextField {

    @IBOutlet
    var next: UIView?

    class func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !textField.resignFirstResponder() {
            return false
        }

        if let textField = textField as? ChainedTextField {
            textField.next?.becomeFirstResponder()
        }

        return true
    }

}
