//
//  Branch.swift
//  XcodeProjects
//
//  Created by zQiu on 2024/4/3.
//  Copyright © 2024 com.klm.mac.myProjects. All rights reserved.
//

import Foundation

class Branch: ObservableObject {
    
    let path: String
    
    @Published
    var name: String = ""
    
    init(path: String) {
        self.path = path
        self.update()
    }
    
    func update() {
        // /Users/zqiu/Projects/lrts-ios/iphone2_0
        let lastComponent = (path as NSString).lastPathComponent
        let git: String
        if lastComponent == "iphone2_0" {
            // iPhone2_0 is the root project dir, go up one more level to find .git
            git = (path as NSString).deletingLastPathComponent
        } else {
            git = path
        }
        let ref = (try? String(contentsOfFile: git + "/.git/HEAD"))
        let bra = ref?.components(separatedBy: "heads/").last
        name = bra?.replacingOccurrences(of: "\n", with: "") ?? ""
    }
}
