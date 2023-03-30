//
//  Socket.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import Foundation
import Starscream


class SocketClientManager{
    var socket : WebSocket
    var isConnected : Bool
    init() {
        var request = URLRequest(url: URL(string: "http://172.20.10.2:8000/")!)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.isConnected = false
        setupSocketEvents()
        self.socket.connect()
        self.socket.write(string: "Hi Server!")
        self.socket.delegate =
    }
    
    func setupSocketEvents() {
        self.socket.onEvent = { event in
            switch event {
                case .connected(let headers):
                    self.isConnected = true
                    print("websocket is connected: \(headers)")
                case .disconnected(let reason, let code):
                    self.isConnected = false
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
                    self.isConnected = false
                case .error(let error):
                    self.isConnected = false
                    print("error: \(error)")
            }
        }
    }
    
    
    func varChange(data: EffectData) {
        self.socket.write(string: "\(data.event)/\(data.effect)/\(data.new)")
        //print("should have written?")
    }
}
