//
//  AddAliasButton.swift
//  XcodeProjects
//
//  Created by Dima Kalachniuk on 14/07/2023.
//  Copyright © 2023 com.klm.mac.myProjects. All rights reserved.
//

import SwiftUI

struct AddAliasButton: View {
    
    let action: (() -> Void)
    
    var body: some View {
        IconButton(imageName: "plus", action: action)
    }
}


struct AddAliasButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAliasButton(action: {})
    }
}
