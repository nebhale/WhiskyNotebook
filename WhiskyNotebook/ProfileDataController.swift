// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class ProfileDataController: UITableViewController {
    
    private let logger = Logger(name: "ProfileDataController")
    
    @IBOutlet
    var membership: UILabel?
    
    @IBOutlet
    var name: UILabel?
    
    var userRepositoryMemento: Memento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userRepositoryMemento = UserRepository.instance.subscribe(onUser)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
    private func onUser(user: User) {
        onMain {
            self.name?.text = user.name
            self.membership?.text = user.membership
        }
    }
    
}