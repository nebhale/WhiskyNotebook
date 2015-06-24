// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import Foundation
import ReactiveCocoa


protocol NotificationRepository {
    var notifications: Signal<NSNotification, NoError> { get }
}