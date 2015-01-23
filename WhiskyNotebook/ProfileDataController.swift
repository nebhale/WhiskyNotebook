// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class ProfileDataController: UITableViewController {
    
    private let logger = Logger(name: "ProfileDataController")
    
    @IBOutlet
    var membership: UILabel?
    
    @IBOutlet
    var name: UILabel?
    
    var user: User? {
        didSet {
            onMain {
                self.name?.text = self.user?.name
                self.membership?.text = self.user?.membership
            }
        }
    }
    
    var userRepositoryMemento: Memento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userRepositoryMemento = UserRepository.instance.subscribe { self.user = $0 }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
}