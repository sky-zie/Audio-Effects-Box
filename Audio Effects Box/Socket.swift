//
//  Socket.swift
//  Audio Effects Box
//
//  Created by Skyler Zieske on 3/15/23.
//

import Foundation
import SocketIO

class SocketClientManager{
    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil
    init() {
        setupSocket()
        setupSocketEvents()
        socket?.connect()
    }
   
    
    func setupSocket() {
        self.socket = manager.defaultSocket
    }
    
    func setupSocketEvents() {
        socket?.on(clientEvent: .connect) {_,_ in
                print("socket connected")
            }
    }
    
    
    func varChange(change: EffectChange) {
        socket?.emit("change", change.socketRepresentation())
        print("heyyy")
    }
}
