//
//  ProfileRowView.swift
//  BudgetTracking
//
//  Created by user244521 on 9/28/23.
//

import SwiftUI

struct ProfileRowVIew: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct SettingsRowVIew_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRowVIew(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}



