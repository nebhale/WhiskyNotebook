// Copyright 2014 Ben Hale. All Rights Reserved

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}