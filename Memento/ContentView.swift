//
//  ContentView.swift
//  Memento
//
//  Created by Russ (thelionshire) on 5/25/20.
//  Copyright © 2020 Ubik Capital. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var myAddress = IconServices.shared.myAddress
    var myBalance = IconServices.shared.myBalance.description
    var myImage = Image("iconimg")
    
    var body: some View {
        // vertical stack with pertinent info 
        VStack(alignment: .center){
            myImage
                
            Text("Welcome to Memento!").font(.title)
            Text("Upload your images to the ICON Blockchain").font(.subheadline)
            Text("\n Address:" + myAddress!).font(.subheadline)
            Text("\n Balance:" + myBalance).font(.subheadline)
            
            // button to take picture..todo need to add camera functions
            Button(action: {
                print(self.myAddress!)
            }){
                HStack {
                    Image(systemName: "camera")
                        .font(.title)
                    Text("Take Picture")
                        .font(.title)
                    }.frame(minWidth: 0, maxWidth:.infinity)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(50)
            }
            // button for uploading image to ICON
            Button(action: {
                let base64ImageString = self.getImageData()
                let uploadHash = IconServices.shared.loadImage(base64ImageString: base64ImageString)
                print(uploadHash)
            }){
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                    Text("Upload")
                        .font(.title)
                    }.frame(minWidth: 0, maxWidth:.infinity)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(50)
            }
        }.padding()
    }
    
    func getImageData() -> String{
        //todo modify to actually take camera image and convert
        let myUIImage = UIImage(named: "iconimg")
        let imageData = myUIImage!.pngData()
        //let imageData = myUIImage!.jpegData(compressionQuality: 0)
        let base64ImageString = imageData?.base64EncodedString()
        return base64ImageString!
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
