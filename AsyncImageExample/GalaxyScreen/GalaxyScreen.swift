//
//  GalaxyScreen.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import SwiftUI

struct GalaxyScreen: View {
    
    @State var useLazyVStack: Bool = false
    @ObservedObject var model = GalaxyScreenModel()
    
    var body: some View {
        
        Group {
            if useLazyVStack {
                lazyStack
            } else {
                list
            }
        }
        .safeAreaInset(edge: .bottom) {
            
            VStack {

                Toggle(isOn: $useLazyVStack) {
                    Text("List/LazyVStack")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.white)
                }
                .frame(width: 200)
                
                FpsMonitorView(printInConsole: false)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.all, 8)
            }
        }
    }
    
    var list: some View {
        
        List {
            
            ForEach(model.items) { item in
                itemView(item)
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            
            loaderView
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .background(.accent)
    }
    
    var lazyStack: some View {
        
        ScrollView {
            LazyVStack {
                
                ForEach(model.items) { item in
                    itemView(item)
                }
                
                loaderView
            }
        }
        .background(.accent)
    }
    
    func itemView(_ item: ItemViewModel) -> some View {
        VStack {
            VStack {
                Text(item.title)
                    .font(.title3)
                    .padding(.all, 8)
                    .foregroundStyle(.white)
                
                AsyncImageView(model: item.imageModel)
                    .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.accent)
    }
    
    var loaderView: some View {
        
        LoaderView()
            .padding(.all, 16)
            .task {
                await model.fetchItems()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)

    }
}

#Preview {
    GalaxyScreen()
}
