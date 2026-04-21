//
//  ResultView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//

import SwiftUI

struct ResultView: View {
    
    @StateObject var viewModel: ResultViewModel
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        content
            .onReceive(viewModel.event, perform: handleEvent)
            .navigationBarTitle("Result", displayMode: .inline)
            .onDisappear {
                viewModel.removeLocalFile()
            }
    }
    
    var content: some View {
        VStack {
            videoPreview
            saveButton
            retryButton
            shareButton
        }
        .padding(25)
        .alert(isPresented: $viewModel.showErrorAlert) {
            saveFailedAlert
        }
    }
    
    var videoPreview: some View {
        VideoPreviewView(url: viewModel.url)
            .frame(width: 167, height: 263)
            .cornerRadius(14)
        
    }
    
    var saveButton: some View {
        Button {
            Task {
                await viewModel.tapSaveButton()
            }
        } label: {
            HStack {
                Image(systemName: iconName)
                Text(buttonTitle)
            }
        }
        .disabled(viewModel.state == .saving || viewModel.state == .saved)
        .buttonStyle(.primaryBlack)
    }
    
    var retryButton: some View {
        Button {
            viewModel.tapRetryButton()
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Retry")
            }
        }
        .buttonStyle(.primaryPurple)
    }
    
    var shareButton: some View {
        ShareLink(item: viewModel.url) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share Video")
            }
        }
        .buttonStyle(.primaryPurple)
    }
    
    private var saveFailedAlert: Alert {
        Alert(
            title: Text("Save Failed"),
            message: Text(viewModel.errorMessage),
            dismissButton: .cancel(Text("OK"))
        )
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

extension ResultView {
    private func handleEvent(_ event: ResultEvent) {
        switch event {
        case .back:
            navigationState.popToRoot()
        }
    }
}


#Preview {
    NavigationStack {
        ResultView(viewModel: ResultViewModel(url: URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")!))
    }
  
}
