//
//  DocumentView.swift
//  Documentlibrary
//
//  Created by Sumit on 26/07/24.

import SwiftUI
import UniformTypeIdentifiers

struct DocumentView: View {
    
    @State private var document: InputDoument = InputDoument(input: "")
    @State private var isImporting: Bool = false
    
    var body: some View {
        VStack {
            Button(action: { isImporting = true}, label: {
                Rectangle()
                    .fill(.red)
                    .frame(width:220,height:60)
                    .cornerRadius(30)
                    .overlay(content: {
                        Text("Open file Manager")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .semibold, design: .default))
                 })
            })
            Text(document.input)
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                if selectedFile.startAccessingSecurityScopedResource() {
                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    defer { selectedFile.stopAccessingSecurityScopedResource() }
                    document.input = input
                } else {
                    // Handle denied access
                }
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
    }
    
 }
    

#Preview {
    DocumentView()
}
