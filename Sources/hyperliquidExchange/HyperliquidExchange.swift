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
    
    
    
    public func metaInfo() async throws -> ExchangeMetaResponse {
        return try await self._postAction(request: ["type": "meta"], path: "/info")
    }
    
    public func spotMetaInfo() async throws -> ExchangeSpotMetaResponse {
        return try await self._postAction(request: ["type": "spotMeta"], path: "/info")
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
    
    public func withdraw(action: ExchangeWithdrawAction, onRequestReady: ((ExchangeRequest) throws -> ExchangeSignature)) async throws -> Bool {
        var request = ExchangeRequest(action: action, nonce: action.time)
        request.signature = try onRequestReady(request)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        switch response.response {
        case .result(let exchangeResponseResult):
            guard exchangeResponseResult.type == "default" else {
                throw ExchangeResponseError.InvalidResponse
            }
            return true
        case .errorMessage(let string):
            throw ExchangeResponseError.Other(string)
        }
    }
    
    public func spotSend(action: ExchangeSpotSendAction, onRequestReady: ((ExchangeRequest) throws -> ExchangeSignature)) async throws -> Bool {
        var request = ExchangeRequest(action: action, nonce: action.time)
        request.signature = try onRequestReady(request)
        let response: ExchangeResponse<ExchangeOrderStatusItem> = try await self.postAction(request: request, path: "/exchange")
        switch response.response {
        case .result(let exchangeResponseResult):
            guard exchangeResponseResult.type == "default" else {
                throw ExchangeResponseError.InvalidResponse
            }
            return true
        case .errorMessage(let string):
            throw ExchangeResponseError.Other(string)
        }
    }
    
    public func postAction<T: Decodable> (request: ExchangeRequest, path: String) async throws -> ExchangeResponse<T> {
        let requestBody = try request.payload()
        let response: ExchangeResponse<T> = try await _postAction(request: requestBody, path: path)
        return response
    }
    
    private func _postAction<T: Decodable> (request: [String: Any], path: String) async throws -> T {
        let dataTask = AF.request(
            "\(url)\(path)",
            method: .post,
            parameters: request,
            encoding: JSONEncoding.default,
            headers: [
                "Content-Type": "application/json"
            ]
        ).serializingDecodable(T.self)
        return try await dataTask.value
    }
}
