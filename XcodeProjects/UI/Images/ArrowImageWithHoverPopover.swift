//
//  ArrowImageWIthHoverPopover.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 01/07/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI

struct ArrowImageWithHoverPopover: View {
    let project: Project
    @State private var noProjectHover: Bool = false

    private var hasOpenableProject: Bool {
        project.hasXcodeProject || project.isAndroidProject || project.isHarmonyProject
    }

    var body: some View {
        ArrowImage()
        .opacity(hasOpenableProject ? 1.0 : 0.1)
        .onHover(perform: { hovered in
            if !self.hasOpenableProject {
                self.noProjectHover = hovered
            }
        })
        .popover(isPresented: $noProjectHover, content: {
            VStack(alignment: .trailing, spacing: 6) {
                Text("No Xcode/Android/Harmony project was found 😔")
            }
            .foregroundColor(Color(.secondaryLabelColor))
            .font(.system(size: 11))
            .padding()
        })
    }
}

struct ArrowImageWIthHoverPopover_Previews: PreviewProvider {
    static var previews: some View {
        ArrowImageWithHoverPopover(project: Project.dummy)
    }
}
