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
        if application "Ghostty" is running then
            tell application "Ghostty"
                activate
                if (count of windows) > 0 then
                    set win to front window
                    set t to new tab in win
                    set term to focused terminal of selected tab of win
                    input text "\(command)\n" to term
                else
                    delay 0.5
                    set win to new window
                    set term to focused terminal of selected tab of win
                    input text "\(command)\n" to term
                end if
            end tell
        else
            tell application "Ghostty"
                activate
                set win to new window
                set t to terminal 1 of selected tab of win
                input text "\(command)" to t
                send key "enter" to t
            end tell
        end if
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
