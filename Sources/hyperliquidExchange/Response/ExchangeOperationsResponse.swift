//
//  ExchangeOperationsResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//
import Foundation
public struct ExchangeOperationAddresses: Decodable {
    public var sourceCoinType: String
    public var destinationChain: String
    public var address: String
    public var signatures: [String: String]
}

public enum ExchangeOperationStatus: Decodable, Equatable {
    case sourceTxDiscovered
    case waitForSrcTxFinalization
    case done
    case unknown(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw {
        case "sourceTxDiscovered":
            self = .sourceTxDiscovered
        case "waitForSrcTxFinalization":
            self = .waitForSrcTxFinalization
        case "done":
            self = .done
        default:
            self = .unknown(raw)
        }
    }
}

public struct ExchangeOperationModel: Decodable {
    public var opCreatedAt: String
    public var operationId: String
    public var protocolAddress: String
    public var sourceAddress: String
    public var destinationAddress: String
    public var sourceChain: String
    public var destinationChain: String
    public var sourceAmount: String
    public var destinationFeeAmount: String
    public var sweepFeeAmount: String
    public var stateStartedAt: String
    public var stateUpdatedAt: String
    public var stateNextAttemptAt: String
    public var sourceTxHash: String
    public var sourceTxConfirmations: Int?
    public var destinationTxHash: String
    public var broadcastAt: String?
    public var asset: String
    public var state: ExchangeOperationStatus
}

public struct ExchangeOperationsResponse: Decodable {
    public var addresses: [ExchangeOperationAddresses]
    public var operations: [ExchangeOperationModel]
}

public enum ExchangeOperationsResponseStatus: Decodable {
    case success(ExchangeOperationsResponse)
    case error(String)
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let response = try? container.decode(ExchangeOperationsResponse.self){
            self = .success(response)
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
