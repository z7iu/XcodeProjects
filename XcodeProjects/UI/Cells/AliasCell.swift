//
//  AliasCell.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 29/06/2022.
//  Copyright © 2022 com.klm.mac.myProjects. All rights reserved.
//

import SwiftUI

struct AliasCell: View {
    let alias: Alias
    @EnvironmentObject var preferences: Preferences
    var completion: (() -> Void)?

    var body: some View {
        
        VStack {
            HStack(spacing: LiquidGlass.isAvailable ? 6 : 0) {
                
                AliasNameView(alias: alias)
                    .glassTile(interactive: true)

                if !LiquidGlass.isAvailable {
                    Divider()
                        .frame(width: 2)
                        .padding(0)
                }

                MenuButton(label: ActionsMenuText()) {
                    Button(action: {
                        preferences.removeAlias(alias)
                    }) {
                        Text("Remove \(alias.name) from the list")
                    }
                }
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .frame(width: 40, height: 40, alignment: .center)
                .legacyBackground(RoundedCorners.right)
                .modifier(OnHover(tl: 0, tr: 12, bl: 0, br: 12))
                .modifier(OnHoverText())
                .glassTile(interactive: true)
            }
        }
        .legacyBackground(RoundedCorners.all)
        .onTapGesture {
            AppDelegate.closePopover()
            NSWorkspace.execute(command: .alias(command: alias.name))
            completion?()
        }
    }
}
