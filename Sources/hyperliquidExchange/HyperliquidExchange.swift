// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import web3swift
import Alamofire
public class HyperliquidExchange{
    public var url: String
    public var vaultAddress: String?
    public init(url: String = "https://api.hyperliquid.xyz", vaultAddress: String? = nil) {
        self.url = url
        self.vaultAddress = vaultAddress
    }
    
    public func placeOrder(action: ExchangePlaceOrderAction, onRequestReady: ((ExchangeRequest) throws -> ExchangeSignature)) async throws -> ExchangeOrderStatusItem {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        var request = ExchangeRequest(action: action, nonce: timestamp)
        request.signature = try onRequestReady(request)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        switch response.response {
        case .result(let exchangeResponseResult):
            guard let item = exchangeResponseResult.data?.statuses.first else {
                throw ExchangeResponseError.InvalidResponse
            }
            return item
        case .errorMessage(let string):
            throw ExchangeResponseError.Other(string)
        }
    }
    
    public func cancelOrder(action: ExchangeCancelOrderAction, onRequestReady: ((ExchangeRequest) throws -> ExchangeSignature)) async throws -> Bool {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        var request = ExchangeRequest(action: action, nonce: timestamp)
        request.signature = try onRequestReady(request)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        switch response.response {
        case .result(let exchangeResponseResult):
            guard let item = exchangeResponseResult.data?.statuses.first else {
                throw ExchangeResponseError.InvalidResponse
            }
            switch item {
            case .success(_):
                return true
            default:
                return false
            }
        case .errorMessage(let string):
            throw ExchangeResponseError.Other(string)
        }
    }
    
    public func usdTransfer(action: ExchangeUsdClassTransferAction, onRequestReady: ((ExchangeRequest) throws -> ExchangeSignature)) async throws -> Bool {
        var request = ExchangeRequest(action: action, nonce: action.nonce)
        request.signature = try onRequestReady(request)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        guard response.status == "ok" else {
            throw ExchangeResponseError.InvalidResponse
        }
        return true
    }
    
    public func postAction<T: Decodable> (request: ExchangeRequest, path: String) async throws -> ExchangeResponse<T> {
        let requestBody = try request.payload()
        let dataTask = AF.request(
            "\(url)\(path)",
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
