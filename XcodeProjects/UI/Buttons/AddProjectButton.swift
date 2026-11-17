//
//  PlusButton.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 17/06/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI

struct AddProjectButton: View {

    let action: (() -> Void)

    var body: some View {
        IconButton(imageName: "add", action: action)
    }
}

