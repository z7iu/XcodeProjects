//
//  MainView.swift
//  StatusBuddy
//
//  Created by Dima Kalachniuk on 09/03/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {

    @State private var searchTerm = ""
    //@State private var listToShow: ListToDisplay = .projects
    @State private var listToShow: Int = 0
    @State private var draggingProject: Project?
    @EnvironmentObject var preferences: Preferences

//    enum ListToDisplay: Int {
//        case projects = 0
//        case aliases
//    }
    
    private var projects: [Project] {
        preferences.projects.filter({ searchTerm.isEmpty ? true : $0.name.lowercased().contains(searchTerm.lowercased()) })
    }

    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: LiquidGlass.isAvailable ? 8 : 15) {
                Spacer().frame(width: 0)
                searchField
                AddProjectButton(action: addProject)
                AddCustomCommandButton(action: addCustomCommand)
                PreferencesView()
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
            .glassContainer(spacing: 8)

            if !LiquidGlass.isAvailable {
                Divider().padding([.top], 3)
            }

            if listToShow == 0 || preferences.showAliases == false {
                if projects.isEmpty {
                    Spacer()
                    if searchTerm.isEmpty {
                        VStack {
                            HStack {
                                Text("Please add a project")
                                AddProjectButton(action: addProject)
                            }
                        }

                    } else {
                        Text("No projects")
                    }
                    Spacer()
                } else {
                    VStack {
                        if self.preferences.hintDisabled == false {
                            HintView().environmentObject(self.preferences)
                        }
                        if LiquidGlass.isAvailable {
                            glassList {
                                ForEach(projects) { project in
                                    ProjectCell(project: project).environmentObject(self.preferences)
                                        .onDrag {
                                            draggingProject = project
                                            return NSItemProvider(object: project.id.uuidString as NSString)
                                        }
                                        .onDrop(of: [UTType.text], delegate: ProjectDropDelegate(target: project,
                                                                                               projects: projects,
                                                                                               dragging: $draggingProject,
                                                                                               move: move))
                                }
                            }
                        } else {
                            List {
                                ForEach(projects) { project in
                                    ProjectCell(project: project).environmentObject(self.preferences)
                                }
                                .onMove(perform: move)
                            }
                            .padding(0)
                        }
                    }
                }
            } else {
                VStack {
                    Spacer().frame(height: 10)
                    HStack(spacing: 10) {
                        Text("Add aliases from custom script file")
                        AddProjectButton(action: parseCustomScriptFile)
                        Text("Add alias")
                        AddAliasButton(action: addCustomAlias)
                    }
                    
                    let allAliases = preferences.aliases
                    if allAliases.isEmpty {
                        Group {
                            Spacer()
                            Text("No aliases were detected. Please add them")
                            Spacer()
                        }
                    } else {
                        if LiquidGlass.isAvailable {
                            glassList {
                                ForEach(allAliases) { alias in
                                    AliasCell(alias: alias, completion: nil).environmentObject(self.preferences)
                                }
                            }
                        } else {
                            List {
                                ForEach(allAliases) { alias in
                                    AliasCell(alias: alias, completion: nil).environmentObject(self.preferences)
                                }
                            }
                        }
                    }
                }
            }
            
            if preferences.showAliases {
                Picker("", selection: $listToShow) {
                    Text("Projects").tag(0)
                    Text("Aliases").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading], -8)
                .padding()
            }
        }
    }
    
    /// List 的每行是独立宿主视图，玻璃采样不到弹窗背景会垫一层灰底，所以 macOS 26 改用 ScrollView
    private func glassList<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                content()
            }
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 10, trailing: 10))
        }
    }

    @ViewBuilder
    private var searchField: some View {
        if LiquidGlass.isAvailable {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search in projects", text: $searchTerm)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 10)
            .frame(width: 215, height: 28)
            .glass(in: Capsule())
        } else {
            TextField("Search in projects", text: $searchTerm)
                .frame(width: 215)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        if searchTerm.isEmpty {
            preferences.moveProjects(from: source, to: destination)
        }
    }
}

extension MainView {
    
    private func parseCustomScriptFile() {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let dialog = NSOpenPanel()
        dialog.title = "Choose script file to parse"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = true
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = true
        dialog.canChooseFiles = true
        dialog.becomesKeyOnlyIfNeeded = true

        appDelegate?.closePopover(sender: nil)

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            
            let newProfileFiles = dialog.urls.map{ProfileFile.custom(name: $0.lastPathComponent, path: $0.standardizedFileURL)}
            preferences.addAliases(newProfileFiles.flatMap{$0.aliases})
        } else {
            print("something went wrong")
        }
        appDelegate?.showPopover(sender: nil)
    }
    
    private func addProject() {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let dialog = NSOpenPanel()
        dialog.title = "Choose a folder with your project/workspace"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = true
        dialog.canChooseFiles = false
        dialog.becomesKeyOnlyIfNeeded = true

        appDelegate?.closePopover(sender: nil)

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let projectUrls = dialog.urls
            let projects = projectUrls.compactMap { Project(url: $0) }
            preferences.addProjects(projects)
            appDelegate?.showPopover(sender: nil)
        } else {
            print("something went wrong")
            appDelegate?.showPopover(sender: nil)
        }
    }
    
    private func addCustomCommand() {
        let controller = ProjectPreferencesViewController(preferences: preferences,
                                                          type: .addTerminalCommand)
        controller.window?.title = "Add custom command"
        controller.showWindow(nil)
        AppDelegate.closePopover()
    }
    
    private func addCustomAlias() {
        let controller = ProjectPreferencesViewController(preferences: preferences,
                                                          type: .addAlias)
        controller.window?.title = "Add custom alias"
        controller.showWindow(nil)
        
        AppDelegate.closePopover()
    }
}

private struct ProjectDropDelegate: DropDelegate {
    let target: Project
    let projects: [Project]
    @Binding var dragging: Project?
    let move: (IndexSet, Int) -> Void

    func dropEntered(info: DropInfo) {
        guard let dragging = dragging, dragging != target,
              let from = projects.firstIndex(of: dragging),
              let to = projects.firstIndex(of: target) else { return }
        withAnimation {
            move(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        dragging = nil
        return true
    }
}
