// Copyright 2014-2015 Ben Hale. All Rights Reserved

public class DramRepositoryManager {
    public static let sharedInstance: DramRepository = InMemoryDramRepository() // TODO: Change once there's a CK implementation
}