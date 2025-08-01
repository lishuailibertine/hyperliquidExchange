//
//  HyperliquidSocket.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
import Foundation
import Starscream
public class HyperliquidSocket: WebSocketDelegate {
    public var socket: WebSocket!
    public var isConnected = false
    public init(url: String = "wss://api.hyperliquid.xyz/ws") {
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        self.socket.connect()
    }
    
//    public func request()
    // MARK: - WebSocketDelegate
    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(_):
            isConnected = true
        case .disconnected(_, _):
            isConnected = false
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
            isConnected = false
            handleError(error)
        case .peerClosed:
            break
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
