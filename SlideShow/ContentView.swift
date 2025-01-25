//
//  ContentView.swift
//  SlideShow
//
//  Created by Lenard Howell on 1/24/25.
//

import SwiftUI
import Foundation
struct ContentView: View {
    let fileManager = FileManager.default
    
    @State var isRunning = false
    @State private var currentPage = 0
    @State private var playPauseImageName = "play.fill"
    @State private var showFileImporter = false
    @State private var urlsWithDateSorted: [UrlWithDate] = []
    
    var body: some View {
        VStack {
            Button("Select Folder") {
                showFileImporter.toggle()
            }
            .font(.largeTitle)
            .fontWeight(.bold)

            TabView(selection: $currentPage) {
                ForEach (0..<urlsWithDateSorted.count, id: \.self) { index in
                    let path = urlsWithDateSorted[index].actualURL.path
                    let uiImage = UIImage(contentsOfFile: path)!
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                    } //Index
            } //TabView
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: .infinity)
            .cornerRadius(10)

            Spacer()
            
            HStack {
                Button("", systemImage: "backward.end.fill")  { // Go back to beginning
                    withAnimation {
                        if urlsWithDateSorted.isEmpty {return}
                        currentPage = 0
                    } // With Animation
                } //Button
                .font(.title)
                .fontWeight(.bold)
//                .padding(.horizontal,10)
                
                Button("", systemImage: "backward.fill")  { // Go back 1 picture
                    withAnimation {
                        if urlsWithDateSorted.isEmpty {return}
                        currentPage = (currentPage - 1 + urlsWithDateSorted.count) % urlsWithDateSorted.count
                    } // With Animation
                } //Button
                .font(.title)
//                .padding(.horizontal,10)
                
                Button("", systemImage: playPauseImageName){    // Play/Pause
                    isRunning.toggle()
                    if isRunning {
                        playPauseImageName = "pause.fill"
                    } else {
                        playPauseImageName = "play.fill"
                    }
                } //Button
                .frame(width: 36, height: 36)
                .font(.title)
                
                Button("", systemImage: "forward.fill") {       // Go Forward One Picture
                    withAnimation {
                        if urlsWithDateSorted.isEmpty {return}
                        currentPage = (currentPage + 1) % urlsWithDateSorted.count
                        }// With Animation
                    } //Button
                .font(.title)
                //.padding(.horizontal,10)
            
            Button("", systemImage: "forward.end.fill") {       // Go Forward to End
                withAnimation {
                    currentPage =  urlsWithDateSorted.count-1
                }// With Animation
                } //Button
            .font(.title)
            //.padding(.horizontal,10)
        } //HStack


            .onReceive(timer) { _ in
                withAnimation {
                    if isRunning{
                        if urlsWithDateSorted.isEmpty {return}
                        currentPage = (currentPage + 1) % urlsWithDateSorted.count
                    }
                }
            } //onReceive
            
        } // VSTack

        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.folder], onCompletion: { (Result) in
            do {
                let folderURL = try Result.get()
//                   print("🤣",folderURL)
                let urlsWithDate = getUrlsWithDate(folderURL: folderURL)
                urlsWithDateSorted = urlsWithDate.sorted { $0.dateStr < $1.dateStr }
                for item in urlsWithDateSorted {
                    print("✅",item.actualURL.lastPathComponent, item.dateStr)
            }// Next
                
                }
                catch{
                    print("error reading file \(error.localizedDescription)")
                }

            })
    }  // Body
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func getUrlsWithDate(folderURL: URL) -> [UrlWithDate] {
        var fileUrls = [URL]()
        
        do {
            fileUrls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("⛔️ \(folderURL)",error.localizedDescription)
        }

        let filteredURLs = fileUrls.filter { $0.lastPathComponent.count > 40 }
        let urlsWithDate = filteredURLs.map { UrlWithDate(actualURL: $0) }
    
        return urlsWithDate
    }//func getUrlsWithDate

} // Struct ContentView


#Preview {
    ContentView()
}


/*
    TO DO:
 1. Start Stop Button
 2. Previous/Next
 3. Import files from RenameCamera File
 4. Ectract Dates From File Namers (RenameCamera File)
 5. Internal sort by Date
 
*/




