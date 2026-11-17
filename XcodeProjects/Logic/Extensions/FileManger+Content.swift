//
//  FileManger+Content.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 20/06/2020.
//  Copyright © 2020 com.dkcompany.xcodeprojects. All rights reserved.
//

import Foundation

extension FileManager {

    func getWorkspaceFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), by: "xcworkspace")?.first
    }

    func getXcodeProjFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), by: "xcodeproj")?.first
    }
    
    func getSwiftPackageFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), byName: "Package.swift")?.first
    }

    func getPodfileLockFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), byName: "Podfile.lock")?.first
    }

    func getPodfile(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), byName: "Podfile")?.first
    }

    func getAndroidProjectFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), byName: "build.gradle")?.first
            ?? filter(urls: contentsOf(project: project), byName: "build.gradle.kts")?.first
            ?? filter(urls: contentsOf(project: project), byName: "settings.gradle")?.first
            ?? filter(urls: contentsOf(project: project), byName: "settings.gradle.kts")?.first
    }

    func getHarmonyProjectFrom(for project: Project) -> URL? {
        filter(urls: contentsOf(project: project), byName: "build-profile.json5")?.first
    }

    func getXcodeDerivedData(for project: Project) -> URL? {
        guard let urls = contentsOf(url: URL(string: directDerivedDataFolderPath)) else {
            return nil
        }
        return urls.first(where: { $0.absoluteString.lowercased().contains(project.name.lowercased()) })
    }
}

private extension FileManager {

    func contentsOf(url: URL?) -> [URL]? {
        guard let urlPath = url else {
            return nil
        }
        do {
            let fileURLs = try contentsOfDirectory(at: urlPath, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error while enumerating files \(urlPath): \(error.localizedDescription)")
            return nil
        }
    }

    func contentsOf(project: Project) -> [URL]? {
        contentsOf(url: project.urlPath)
    }

    func filter(urls: [URL]?, by pathExtension: String) -> [URL]? {
        urls?.filter({ $0.pathExtension == pathExtension })
    }

    func filter(urls: [URL]?, byName name: String) -> [URL]? {
        urls?.filter({ $0.lastPathComponent == name })
    }
}
