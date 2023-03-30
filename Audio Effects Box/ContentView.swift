//
//  ContentView.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import SwiftUI
import Controls


struct ContentView: View {
    let sock = SocketClientManager()
    @State var cutoff : Float = 0
    @State var pitch : Float = 0
    @State var reverb: Float = 0
    @State var pitchBend: Float = 0
    
    var body: some View {
        VStack {
            EffectView(name: "Reverb", val: $reverb, color: .blue, sock: sock)
            EffectView(name: "Filter", val: $cutoff, color: .yellow, sock: sock)
            EffectView(name: "Pitch", val: $pitch, color: .red, sock: sock)
        }
    }
}

struct EffectView: View {
    let name : String
    @Binding var val: Float
    let color : Color
    let sock : SocketClientManager
    
    var body: some View {
        // use the `val` property here
        ArcKnob(name, value: $val)
            .foregroundColor(color)
            .onChange(of: val, perform: {_ in
                sock.varChange(data:
                    EffectData(event : "change", effect : name, new : val)
                )
            } )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EffectData {
    let event: String
    let effect: String
    let new: Float
}
