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
            toggle
            searchTextField
            regionListView
        }
        .background(.armonyBlack)
    }
    
    private var toggle: some View {
        Toggle(isOn: $viewModel.isActive) {
            Text(viewModel.region)
                .foregroundStyle(.armonyWhite)
        }
        .padding()
        .background(content: {
            Color.armonyBlue20
        })
        .padding()
    }
    
    private var searchTextField: some View {
        TextField("", text: $viewModel.searchText)
            .textFieldStyle(.plain)
            .padding()
            .foregroundStyle(.armonyWhite)
            .background {
                Text(viewModel.searchText.isEmpty ? "Search" : .empty)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.armonyWhite04)
                    .padding(.horizontal)
            }
            .background(.armonyBlue20)
            .padding(.horizontal)
            .cornerRadius(1.0)
    }
    
    private var regionListView: some View {
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
        .padding(.vertical)
        .scrollContentBackground(.hidden)
    }
}

@available(iOS 16, *)
#Preview {
    RegionsView(viewModel: .init())
}
