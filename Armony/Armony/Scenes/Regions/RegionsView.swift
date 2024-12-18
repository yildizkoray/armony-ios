//
//  RegionsView.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/12/2024.
//

import SwiftUI

@available(iOS 16, *)
struct RegionsView: View {
    
    @ObservedObject var viewModel: RegionsViewModel
    
    var body: some View {
        VStack {
            Toggle(isOn: $viewModel.isActive) {
                Text(viewModel.region)
                    .foregroundStyle(.armonyWhite)
            }
            .padding()
            .background(content: {
                Color.armonyBlue20
            })
            .padding()
            
            List(viewModel.regions, id: \.id) { region in
                HStack {
                    Text(region.displayName)
                        .foregroundStyle(Color.armonyWhite)
                    Spacer()
                    let image = (viewModel.region == region.code) ? .strokedCheckmark : UIImage()
                    Image(uiImage: image)
                        .renderingMode(.template)
                        .foregroundStyle(Color.armonyWhite)
                }
                .contentShape(Rectangle())
                .listRowBackground(Color.armonyBlack)
                .listRowSeparatorTint(.armonyWhite04)
                .onTapGesture {
                    if viewModel.region == region.code {
                        viewModel.region = .empty
                    }
                    else {
                        viewModel.region = region.code
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(.armonyBlack)
    }
}

@available(iOS 16, *)
#Preview {
    RegionsView(viewModel: .init())
}
