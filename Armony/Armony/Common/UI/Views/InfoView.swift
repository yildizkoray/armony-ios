//
//  InfoView.swift
//  Armony
//
//  Created by Koray Yıldız on 26.02.2024.
//

import SwiftUI

struct InfoViewModel {
    let iconName: String
    let text: String
}

struct InfoView: View {
    let viewModel: InfoViewModel

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sixteen.rawValue, content: {
            Image(uiImage: viewModel.iconName.image)
                .padding(.vertical, AppTheme.Spacing.sixteen.rawValue)
                .padding(.leading, AppTheme.Spacing.eight.rawValue)
            Text(viewModel.text)
                .font(Font(UIFont.regularBody as CTFont))
                .foregroundStyle(AppTheme.Color.white.swiftUIColor)
                .padding(.vertical, AppTheme.Spacing.sixteen.rawValue)
                .padding(.trailing, AppTheme.Spacing.eight.rawValue)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        .background(AppTheme.Color.blue20.swiftUIColor)
        .cornerRadius(AppTheme.Radius.medium.rawValue)
    }
}

#Preview {
    InfoView(viewModel: InfoViewModel(
        iconName: "info-icon",
        text: "İlanınızın süresi dolduğu için yayından kaldırılmıştır")
    )
    .padding()
    .background(AppTheme.Color.darkBlue.swiftUIColor)
}
