// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import web3swift

public class HyperliquidExchange{
    public var url: String
    public var vaultAddress: String?
    public init(url: String, vaultAddress: String?) {
        self.url = url
        self.vaultAddress = vaultAddress
    }
    
    public func postAction(request: ExchangeRequest) async {
        
    }
}
