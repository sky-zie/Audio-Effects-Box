//
//  Socket.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import Foundation
import Starscream

class SocketClientManager: ObservableObject, WebSocketDelegate {
    @Published private var socket : WebSocket
    @Published var isConnected : Bool = false
    init() {
        var request = URLRequest(url: URL(string: "ws://172.20.10.8:5000")!)
        request.timeoutInterval = 5
        let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates
        socket = WebSocket(request: request, certPinner: pinner)
        socket.delegate = self
        print("Attempting to connect to server...")
    }
   
    func connect() {
        socket.connect()
        print("did it work?")
    }
    func varChange(data: EffectData) {
        let myString = data.new
        socket.write(string: myString)
    }
    
    func filterBuild(data: FilterData) {
        socket.write(string: "f/\(data.type)/\(data.order)/\(data.low)/\(data.high)")
    }
    
    func didConnect(socket: WebSocket) {
        isConnected = true
        print("WebSocket connected")
    }
    
    func didDisconnect(socket: WebSocket, error: Error?) {
        isConnected = false
        if let error = error {
            print("WebSocket disconnected due to error: \(error.localizedDescription)")
        } else {
            print("WebSocket disconnected")
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            print("WebSocket error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        isConnected = true
        print("WebSocket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        isConnected = false
        if let error = error {
            print("WebSocket disconnected due to error: \(error.localizedDescription)")
        } else {
            print("WebSocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        print("Received pong")
    }
    
    func websocketShouldConvertTextFrame(toString: String) -> Bool {
        return true
    }
}
