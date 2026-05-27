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
        """
        set wasRunning to application "Ghostty" is running
        tell application "Ghostty"
            activate
            if wasRunning and (count of windows) > 0 then
                new tab in front window
            else if wasRunning then
                new window
            else
                repeat until (count of windows) > 0
                    delay 0.1
                end repeat
            end if
            delay 0.5
            set term to focused terminal of selected tab of front window
            input text "\(command)" to term
            send key "enter" to term
        end tell
        """
    }

    init(command: String) {
        self.command = command
    }

    init(toRemovePath: String) {
        self.command = "rm -rf \(toRemovePath)"
    }
}
