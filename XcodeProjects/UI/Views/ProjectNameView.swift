//
//  ProjectNameView.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 22/06/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI

struct ProjectNameView: View {
    
    let project: Project
    @EnvironmentObject var preferences: Preferences
    @ObservedObject var branch: Branch

    var body: some View {
        HStack {

            Spacer()
                .frame(width: 8)

            if self.preferences.showProjectIcon {
                ProjectIcon(project: project).environmentObject(preferences)
            }

            Text(self.project.name)
                .padding([.trailing], 5)
            
            Spacer()
            
            Text(self.branch.name)
                .padding([.trailing], 5)
           
            // open project
            Button(action: {
                AppDelegate.closePopover()
                switch self.project.projectType {
                case .android:
                    NSWorkspace.execute(command: .openInAndroidStudio, forProject: self.project)
                case .harmony:
                    NSWorkspace.execute(command: .openInDevEcoStudio, forProject: self.project)
                default:
                    NSWorkspace.execute(command: .openWorkspace, forProject: self.project)
                }
            }) {
                ArrowImageWithHoverPopover(project: self.project)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding([.trailing], 5)
            .modifier(OnHoverText())

            // open package swift if exists
            if project.hasSwiftPackage {
                Button(action: {
                    AppDelegate.closePopover()
                    NSWorkspace.execute(command: .openSwiftPackage, forProject: self.project)
                }) {
                    PackageSwiftImage()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding([.trailing], 5)
                .modifier(OnHoverText())
            }
            
            Spacer().frame(width: 3)
        }
        .frame(height: 40)
        .background(RoundedCorners.left)
        .modifier(OnHover(tl: 12, tr: 0, bl: 12, br: 0))
    }
}

struct ProjectNameView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectNameView(project: Project.dummy, branch: Branch(path: ""))
    }
}
