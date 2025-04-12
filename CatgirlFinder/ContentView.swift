//
//  ContentView.swift
//  CatgirlFinder
//
//  Created by nyoemii on 11.04.25.
//

import SwiftUI

struct ContentView: View {
    @State var meow: UIImage?
    @State var url: URL?
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    if let meow, let url {
                        Image(uiImage: meow)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 15))
                            .padding()
                        Text(" ")
                        HStack {
                            Link("Source", destination: url)
                                .buttonStyle(.borderedProminent)
                            Button("Refresh") {
                                Task {
                                    await getImage()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        Text(" ")
                        Text(" ")
                        ProgressView("Refreshing..")
                    }
                }
                .navigationTitle("Catgirl Finder")
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .refreshable {
                    await getImage()
                }
                .tint(.accent)
            }
            .tabItem({
                Label("Home", systemImage: "cube.box")
            })
            .task {
                await getImage()
            }
            NavigationStack {
                let url = URL(string: "https://github.com/nyoemii")
                let llsc12 = URL(string: "https://github.com/llsc12")
                Image(systemName: "safari")
                    .font(.largeTitle)
                Text(" ")
                Text("Visit me on my GitHub")
                    .font(.title2)
                    .monospaced()
                Text(" ")
                Link("nyoemii", destination: url!)
                    .font(.title2)
                    .monospaced()
                Text(" ")
                Text("and the person that")
                    .font(.title2)
                    .monospaced()
                Text("teaches me Swift")
                    .font(.title2)
                    .monospaced()
                Text(" ")
                Link("llsc12", destination: llsc12!)
                    .font(.title2)
                    .monospaced()
            }
            .tabItem {
                Label("Credits", systemImage: "moon")
            }
        }
    }
    
    func getImage() async {
        meow = nil
        let url = URL(string: "https://api.nekosia.cat/api/v1/images/catgirl")
        let req = URLRequest(url: url!)
        do {
            let (data, _) = try await URLSession.shared.data(for: req)
//            print(String(data: data, encoding: .utf8))
            let decode = JSONDecoder()
            let response = try decode.decode(Response.self, from: data)
            
            let url = response.image.original.url
            let (imgdata, _) = try await URLSession.shared.data(from: url)
            
            let img = UIImage(data: imgdata)
            meow = img
            self.url = url
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}

struct Response: Codable {
  let image: ImageData
}

struct ImageData: Codable {
  let original: Img
  let compressed: Img
}

struct Img: Codable {
  let url: URL
  let `extension`: String
}
