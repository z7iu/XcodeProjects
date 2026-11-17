//
//  ProjectCell.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 09/03/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI

struct ProjectCell: View {
    let project: Project
    @EnvironmentObject var preferences: Preferences

    var body: some View {
        VStack {
            HStack(spacing: LiquidGlass.isAvailable ? 6 : 0) {
                
                ProjectNameView(project: self.project, branch: preferences.branch(project))
                    .environmentObject(preferences)
                    .glassTile()

                if !LiquidGlass.isAvailable {
                    Divider()
                        .frame(width: 2)
                        .padding(0)
                }

                ProjectMenuView(project: self.project)
                    .environmentObject(preferences)
                    .frame(width: 40, height: 40, alignment: .center)
                    .legacyBackground(RoundedCorners.right)
                    .modifier(OnHover(tl: 0, tr: 12, bl: 0, br: 12))
                    .modifier(OnHoverText())
                    .glassTile(interactive: true)
            }

        }

    }
}

struct ProjectCell_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCell(project: Project.dummy)
    }
}
