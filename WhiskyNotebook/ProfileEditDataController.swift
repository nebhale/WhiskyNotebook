// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class ProfileEditDataController: UITableViewController {
    
    private let logger = Logger(name: "ProfileEditDataController")
    
    @IBOutlet
    var membership: UITextField?
    
    @IBOutlet
    var name: UITextField?
    
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
        
        // Segued View calculates a non-standard row height
        self.tableView.rowHeight = 44
    }
    
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
        
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
    func toUser() -> User? {
        self.user?.name = self.name?.text
        self.user?.membership = self.membership?.text
        
        return self.user
    }
    
}