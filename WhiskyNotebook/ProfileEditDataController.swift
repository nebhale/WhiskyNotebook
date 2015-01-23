// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class ProfileEditDataController: UITableViewController {
    
    private let logger = Logger(name: "ProfileEditDataController")
    
    @IBOutlet
    var membership: UITextField?
    
    @IBOutlet
    var name: UITextField?
    
    var userRepositoryMemento: Memento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userRepositoryMemento = UserRepository.instance.subscribe(onUser)
        
        // Segued View calculates a non-standard row height
        self.tableView.rowHeight = 44
    }
    
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
        
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }
    
    func toUser() -> User {
        return User(id: "", name: self.name?.text, membership: self.membership?.text)
    }
    
    private func onUser(user: User) {
        self.logger.debug { "User updated: \(user)" }
    }
    
}