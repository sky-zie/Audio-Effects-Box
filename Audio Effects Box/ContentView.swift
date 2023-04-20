//
//  ContentView.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import SwiftUI
import Controls


struct ContentView: View {
    @StateObject var sock = SocketClientManager()
    @State var freq: Float = 0
    @State var pitch : Int = 0
    @State var curr : String = "none"
    
    @State var order : String = ""
    @State var h_freq : String = "1000"
    @State var l_freq : String = "100"
    let pitches = ["-2", "-1", "0", "1", "2"]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 40){
            EffectKnob(name: "sine", temp: $freq, sock: sock, current: $curr)
                .frame(height: 300)
            EffectSlider(name : "pitch", ind: $pitch, labels: pitches, sock: sock, current: $curr)
                .frame(height: 30)
            FilterBuilder(sock: sock, order: $order, high: $h_freq, low: $l_freq, current: $curr)
            ConnectionMessage(sock: sock)
            
        }
        .onAppear {
         sock.connect()
       }
        
    }
}

struct EffectKnob: View {
    let name : String
    @Binding var temp: Float
    @State var curr: Float = 100.0
    let color : Color = .gray
    var sock : SocketClientManager
    @Binding var current : String
    let step_size = Float(100.0)
    
    
    var body: some View {
        // use the `val` property here
        ArcKnob(name, value: $temp, range: 100...1000)
            .foregroundColor((current == name) ? Color.green : Color.white)
            .onChange(of: temp, perform: {_ in
                if ((curr - temp) >= step_size || (curr - temp) <= (-1 * step_size)){
                    print("curr \(curr)")
                    curr = temp
                    sock.varChange(data:
                        EffectData(event : "change", effect : name, new : String(temp))
                    )
                }
                current = name
                    
            } )
        }
}

struct EffectSlider: View {
    let name : String
    @Binding var ind: Int
    let labels: [String]
    var sock : SocketClientManager
    let color : Color = .gray
    @Binding var current : String
    
    var body: some View {
        // use the `val` property here
        IndexedSlider(index: $ind, labels: labels)
            .foregroundColor((current == name) ? Color.green : Color.white)
            .backgroundColor(.black.opacity(0.1))
            .cornerRadius(500)
            .onChange(of: ind, perform: {_ in
                sock.varChange(data:
                    EffectData(event : "change", effect : "pitch", new : labels[ind])
                )
                current = name
            } )
    }
}

struct ConnectionMessage : View {
    var sock: SocketClientManager
    let padding : CGFloat? = 0
    let connect_str : String
    init(sock: SocketClientManager) {
        self.sock = sock
        if (self.sock.isConnected) { self.connect_str = "Connected!" }
        else {
            self.connect_str = "    Not Connected..."
        }
    }
    var body: some View {
        HStack {
            Text(connect_str)
                .padding(.top, padding)
            
            if (!self.sock.isConnected){
                Spacer()
                Button(action: {self.sock.connect()}) {
                    Text("Connect")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct FilterBuilder : View {
    let name : String = "filter"
    var sock: SocketClientManager
    @Binding var order :  String
    @Binding var high : String
    @Binding var low : String
    @Binding var current : String
    
    var init_vals = [0, 0, 0]
    @FocusState private var nameIsFocused
    @State private var filterType = "band"
    let filters = ["band", "low", "high"]

    var body: some View {
        VStack {
            HStack (spacing: 3) {
                TextField("Order", text: $order)
                if (filterType != "high") {
                    TextField("High Freq (Hz) ", text: $high)
                }
                if (filterType != "low") {
                    TextField("Low Freq (Hz) ", text: $low)
                }
            }.keyboardType(.numberPad)
              .focused($nameIsFocused)
              .foregroundColor((current == name) ? Color.green : Color.gray)
            HStack {
                Button(action: {
                    if ((Int(low) ?? 0) >= 5) { sock.filterBuild(data:
                        FilterData(type: filterType, order : order, high : high, low : low)
                    ) }
                    current = name
                    nameIsFocused = false
                    
                }) {
                    Text("Build")
                }
                .foregroundColor((current == name) ? Color.green : Color.white)
                
                Picker("text", selection: $filterType) {
                    ForEach(filters, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .accentColor((current == name) ? Color.green : Color.white)
            }
        }.textFieldStyle(.roundedBorder)
         .buttonStyle(.bordered)
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
    let new: String
}

struct FilterData {
    let type : String
    let order: String
    let high: String
    let low: String
}

