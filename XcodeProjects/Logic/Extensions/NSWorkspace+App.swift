//
//  NSWorkspace+App.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 01/07/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI

extension NSWorkspace {
    var sourceTreeAppInstalled: Bool {
        (NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.torusknot.SourceTreeNotMAS") != nil)
    }
    
    var forkAppInstalled: Bool {
        (NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.DanPristupov.Fork") != nil)
    }
    
    var codeBuddyCNAppInstalled: Bool {
        (NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.tencent.codebuddycn") != nil)
    }

    var androidStudioAppInstalled: Bool {
        (NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.google.android.studio") != nil)
    }

    var devEcoStudioAppInstalled: Bool {
        (NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.huawei.deveco-studio") != nil
            || NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.huawei.DevEcoStudio") != nil)
    }
}
