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
        guard let gitDir = Branch.resolveGitDir(for: path) else {
            name = ""
            return
        }
        let ref = (try? String(contentsOfFile: gitDir + "/HEAD"))
        let bra = ref?.components(separatedBy: "heads/").last
        name = bra?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    /// 解析出实际的 git 目录（HEAD 所在目录）。
    /// 普通仓库 `.git` 是目录，worktree 仓库 `.git` 是文件，内容为
    /// `gitdir: /path/to/main/.git/worktrees/<name>`，需要据此跳转。
    private static func resolveGitDir(for path: String) -> String? {
        let fm = FileManager.default

        // 找到包含 .git 的仓库根目录：当前目录或其上级目录
        var dotGit = path + "/.git"
        if !fm.fileExists(atPath: dotGit) {
            dotGit = (path as NSString).deletingLastPathComponent + "/.git"
        }

        var isDir: ObjCBool = false
        guard fm.fileExists(atPath: dotGit, isDirectory: &isDir) else {
            return nil
        }

        // 普通仓库：.git 是目录，直接返回
        if isDir.boolValue {
            return dotGit
        }

        // worktree 仓库：.git 是文件，解析 `gitdir: <path>`
        guard let content = try? String(contentsOfFile: dotGit) else {
            return nil
        }
        for line in content.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("gitdir:") {
                var gitDir = String(trimmed.dropFirst("gitdir:".count))
                    .trimmingCharacters(in: .whitespaces)
                // gitdir 可能是相对路径，需相对 .git 文件所在目录解析
                if !(gitDir as NSString).isAbsolutePath {
                    let base = (dotGit as NSString).deletingLastPathComponent
                    gitDir = (base as NSString).appendingPathComponent(gitDir)
                }
                return (gitDir as NSString).standardizingPath
            }
        }
        return nil
    }
}
