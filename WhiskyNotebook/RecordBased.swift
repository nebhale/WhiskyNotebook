// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CloudKit


protocol RecordBased {

    init(record: CKRecord)

    func toRecord() -> CKRecord

}
