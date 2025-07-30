//
//  ExchangeResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
public enum ExchangeResponseError: Error {
    case InvalidResponse
    case Other(String)
}

public struct ExchangeResponseStatuses<T: Decodable>: Decodable{
    public var statuses: [T]
}
public struct ExchangeResponseResult<T: Decodable>: Decodable{
    public var type: String
    public var data: ExchangeResponseStatuses<T>?
}

public enum ExchangeResponseResultOrError<T: Decodable>: Decodable {
    case result(ExchangeResponseResult<T>)
    case errorMessage(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(ExchangeResponseResult<T>.self) {
            self = .result(result)
        }
        else if let message = try? container.decode(String.self) {
            self = .errorMessage(message)
        }
        else {
            throw DecodingError.typeMismatch(
                ExchangeResponseResultOrError.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected either ExchangeResponseResult<T> or String"
                )
            )
        }
    }
}
public struct ExchangeResponse<T: Decodable>: Decodable{
    public var status: String
    public var response: ExchangeResponseResultOrError<T>
}
public struct ExchangeOrderErrorStatus: Decodable {
    public let error: String
}
// Order
public struct ExchangeOrderFilledStatus: Decodable {
    public let totalSz: String
    public let avgPx: String
    public let oid: Int
}

public struct ExchangeOrderRestingStatus: Decodable {
    public let oid: Int
}

public enum ExchangeOrderStatusItem: Decodable {
    case resting(ExchangeOrderRestingStatus)
    case filled(ExchangeOrderFilledStatus)
    case error(String)
    case success(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self), str == "success" {
            self = .success(str)
            return
        }
        if let object = try? container.decode([String: ExchangeOrderRestingStatus].self),
           let value = object["resting"] {
            self = .resting(value)
            return
        }
        if let object = try? container.decode([String: ExchangeOrderFilledStatus].self),
           let value = object["filled"] {
            self = .filled(value)
            return
        }
        
        if let object = try? container.decode([String: String].self),
           let value = object["error"] {
            self = .error(value)
            return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown status format")
    }
}
