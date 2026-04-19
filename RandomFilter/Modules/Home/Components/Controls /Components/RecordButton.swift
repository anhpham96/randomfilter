//
//  RecordButton.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//
import SwiftUI

struct RecordButton: View {
    
    let isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // viền ngoài
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 70, height: 70)
                
                // bên trong
                Circle()
                    .fill(isRecording ? Color.red : Color.white)
                    .frame(width: isRecording ? 30 : 55,
                           height: isRecording ? 30 : 55)
                    .animation(.easeInOut(duration: 0.2), value: isRecording)
            }
        }
    }
}
