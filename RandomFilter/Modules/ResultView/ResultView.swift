//
//  ResultView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//

import SwiftUI

struct ResultView: View {
    
    let url: URL
    @StateObject private var viewModel = ResultViewModel()
    
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        content
            .navigationBarTitle("Result", displayMode: .inline)
    }
    
    var content: some View {
        VStack {
            
            VideoPreviewView(url: url)
                .frame(width: 167, height: 263)
                .cornerRadius(14)
            
            Button {
                Task {
                    await viewModel.saveVideo(from: url)
                }
            } label: {
                HStack {
                    Image(systemName: iconName)
                    Text(buttonTitle)
                }
            }
            .disabled(viewModel.state == .saving)
            .buttonStyle(.primaryBlack)
            
            Button {
                navigationState.popToRoot()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
            }
            .buttonStyle(.primaryBlack)
        }
        .padding(25)
    }
    
    private var buttonTitle: String {
        switch viewModel.state {
        case .idle: return "Save"
        case .saving: return "Saving..."
        case .saved: return "Saved"
        case .failed: return "Retry"
        }
    }

    private var iconName: String {
        switch viewModel.state {
        case .idle: return "square.and.arrow.down"
        case .saving: return "clock"
        case .saved: return "checkmark"
        case .failed: return "arrow.clockwise"
        }
    }
}

#Preview {
    NavigationStack {
        ResultView(url: URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")!)
    }
  
}
