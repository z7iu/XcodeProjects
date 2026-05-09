//
//  AppleScript.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 20/06/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import Foundation

struct TerminalScript {
    let command: String

    var script: String {
        let scriptText =
        """
        tell application "iTerm"
            activate
            tell (create window with default profile)
                tell current session
                    write text "\(command)"
                end tell
            end tell
        end tell
        """
        return scriptText
    }

    init(command: String) {
        self.command = command
    }

    init(toRemovePath: String) {
        self.command = "rm -rf \(toRemovePath)"
    }
}
