//
//  ExchangeUnitResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
import Foundation
//unit
public struct ExchangeGenerateAddress: Decodable {
    public var address: String
    public var status: String
    public var signatures: [String: String]
}

public enum ExchangeGenerateAddressStatus: Decodable {
    case address(ExchangeGenerateAddress)
    case error(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self), str == "error" {
            self = .error(str)
            return
        }
        if let value = try? container.decode(ExchangeGenerateAddress.self){
            self = .address(value)
            return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown status format")
    }
}

// gas
public struct ExchangeBitcoinEstimate: Decodable {
    public var depositFeeRateSatsPerVb: Int
    public var depositSizeVBytes: Int
    public var depositEta: String
    public var depositFee: Int
    public var withdrawalFeeRateSatsPerVb: Int
    public var withdrawalSizeVBytes: Int
    public var withdrawalEta: String
    public var withdrawalFee: Int
    enum CodingKeys: String, CodingKey {
        case depositFeeRateSatsPerVb = "deposit-fee-rate-sats-per-vb"
        case depositSizeVBytes = "deposit-size-v-bytes"
        case depositEta
        case depositFee
        case withdrawalFeeRateSatsPerVb = "withdrawal-fee-rate-sats-per-vb"
        case withdrawalSizeVBytes = "withdrawal-size-v-bytes"
        case withdrawalEta
        case withdrawalFee
    }
}

public struct ExchangeEthereumEstimate: Decodable {
    public var baseFee: Int
    public var depositEta: String
    public var depositFee: Int
    public var ethDepositGas: Int
    public var ethWithdrawalGas: Int
    public var priorityFee: Int
    public var withdrawalEta: String
    public var withdrawalFee: Int
    enum CodingKeys: String, CodingKey {
        case baseFee = "base-fee"
        case depositEta
        case depositFee
        case ethDepositGas = "eth-deposit-gas"
        case ethWithdrawalGas = "eth-withdrawal-gas"
        case priorityFee = "priority-fee"
        case withdrawalEta
        case withdrawalFee
    }
}

public struct ExchangeSolanaEstimate: Decodable {
    public var depositEta: String
    public var depositFee: Int
    public var withdrawalEta: String
    public var withdrawalFee: Int
}

public struct ExchangeEstimateFees: Decodable {
    public var bitcoin: ExchangeBitcoinEstimate
    public var ethereum: ExchangeEthereumEstimate
    public var solana: ExchangeSolanaEstimate
    public var spl: ExchangeSolanaEstimate
}
