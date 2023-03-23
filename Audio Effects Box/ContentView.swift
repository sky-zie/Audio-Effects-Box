//
//  ContentView.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import SwiftUI
import Controls
import SocketIO

var sock = SocketClientManager()

struct ContentView: View {
    
    @State var cutoff : Float = 0
    @State var pitch : Float = 0
    @State var reverb: Float = 0
    
    var body: some View {
        VStack {
            EffectView(name: "Reverb", val: $reverb, color: .blue)
            EffectView(name: "Filter", val: $cutoff, color: .yellow)
            EffectView(name: "Pitch", val: $pitch, color: .red)
        }
    }
}

struct EffectView: View {
    let name : String
    @Binding var val: Float
    let color : Color
    
    var body: some View {
        // use the `val` property here
        ArcKnob(name, value: $val)
            .foregroundColor(color)
            .onChange(of: val, perform: {_ in
                sock.varChange(change:
                    EffectChange(effect : name, new : val)
                )
            } )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EffectChange: Codable {
    let effect: String
    let new: Float
    
    //init(effect: String, new: Float) {
    //    self.effect = effect
    //    self.new = new
    //}
    
    func socketRepresentation() -> SocketData {
        return ["effect": effect, "new": new]
    }
}
