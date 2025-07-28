// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import web3swift
import Alamofire
public class HyperliquidExchange{
    public var url: String
    public var vaultAddress: String?
    public init(url: String = "https://api.hyperliquid.xyz", vaultAddress: String?) {
        self.url = url
        self.vaultAddress = vaultAddress
    }
    
    public func placeOrder(action: ExchangePlaceOrderAction) async throws -> ExchangeOrderStatusItem {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let request = ExchangeRequest(action: action, nonce: timestamp)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        guard let item = response.response.data?.statuses.first else {
            throw ExchangeResponseError.InvalidResponse
        }
        return item
    }
    
    public func cancelOrder(action: ExchangeCancelOrderAction) async throws -> Bool {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let request = ExchangeRequest(action: action, nonce: timestamp)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        guard let item = response.response.data?.statuses.first else {
            throw ExchangeResponseError.InvalidResponse
        }
        switch item {
        case .success(_):
            return true
        default:
            return false
        }
    }
    
    public func usdTransfer(action: ExchangeUsdClassTransferAction) async throws -> Bool {
        let request = ExchangeRequest(action: action, nonce: action.nonce)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        guard response.status == "ok" else {
            throw ExchangeResponseError.InvalidResponse
        }
        return true
    }
    
    public func postAction<T: Decodable> (request: ExchangeRequest, path: String) async throws -> ExchangeResponse<T> {
        let requestBody = try request.payload()
        let dataTask = AF.request(
            url,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default,
            headers: [
                "Content-Type": "application/json"
            ]
        ).serializingDecodable(ExchangeResponse<T>.self)
        return try await dataTask.value
    }
}
