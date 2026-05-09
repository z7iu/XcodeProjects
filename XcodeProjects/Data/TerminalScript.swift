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
        tell application "Ghostty"
            activate
            set win to new window
            set t to terminal 1 of selected tab of win
            input text "\(command)" to t
            send key "enter" to t
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
