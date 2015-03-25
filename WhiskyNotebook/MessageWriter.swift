// Copyright 2014-2015 Ben Hale. All Rights Reserved

public protocol MessageWriter {

    func write(#configuration: Configuration, level: Level, messagePosition: MessagePosition, @noescape messageProvider: MessageProvider)

}