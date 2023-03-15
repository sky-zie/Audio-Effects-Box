//
//  ContentView.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import SwiftUI
import Controls
import SocketIO

struct ContentView: View {
    @State var val : Float = 0
    var sock = SocketClientManager()
    var body: some View {
        ArcKnob("Filter", value: $val)
            .onChange(of: val, perform: {_ in
                sock.varChange(change:
                    EffectChange(effect : "filter", new : val)
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
