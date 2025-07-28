//
//  ExchangeOrderAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/25.
//
import Foundation
public enum ExchangeLimitOrderType: String, Encodable {
    case ALO // (add liquidity only, i.e. "post only") will be canceled instead of immediately matching.
    case Ioc // (immediate or cancel) will have the unfilled part canceled instead of resting.
    case Gtc // (good til canceled) orders have no special behavior.
}

public enum ExchangeTpslType: String, Encodable{
    case tp
    case sl
}

public struct ExchangeTriggerOrderType: Encodable{
    public var isMarket: Bool
    public var triggerPx: String
    public var tpsl: ExchangeTpslType
}

public struct DynamicCodingKeys: CodingKey {
    public var stringValue: String
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    public var intValue: Int? = nil
    public init?(intValue: Int) {
        return nil // Not used
    }
}

public enum ExchangeOrderType: ExchangeEncodePaload, Encodable {
    case limit(ExchangeLimitOrderType)
    case trigger(ExchangeTriggerOrderType)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        switch self {
        case .limit(let value):
            let nestedEncoder = container.superEncoder(forKey: DynamicCodingKeys(stringValue: "limit")!)
            try value.encode(to: nestedEncoder)
        case .trigger(let value):
            let nestedEncoder = container.superEncoder(forKey: DynamicCodingKeys(stringValue: "trigger")!)
            try value.encode(to: nestedEncoder)
        }
    }
}

public enum ExchangeOrderGroupingType: String, Encodable{
    case na
    case normalTpsl
    case positionTpsl
}

public struct ExchangePlaceOrderPayload: ExchangeEncodePaload, Encodable {
    public var a: Int // asset
    public var b: Bool // isBuy
    public var p: String // price
    public var r: Bool // reduceOnly
    public var s: String // size
    public var t: ExchangeOrderType // type
}

public struct ExchangePlaceOrderAction: ExchangeBaseAction, Encodable{
    public var type: String = "order"
    public var orders: [ExchangePlaceOrderPayload]
    public var grouping: ExchangeOrderGroupingType
}

public struct ExchangeCancelOrderPayload: Encodable {
    public var a: Int // asset
    public var o: Int // is oid (order id)
}

public struct ExchangeCancelOrderAction: ExchangeBaseAction, Encodable {
    public var type: String = "cancel"
    public var cancels: [ExchangeCancelOrderPayload]
}

public struct ExchangeCancelOrderByIdPayload: Encodable {
    public var a: Int // asset
    public var cloid: String
}

public struct ExchangeCancelOrderByIdAction: ExchangeBaseAction, Encodable {
    public var type: String = "cancelByCloid"
    public var cancels: [ExchangeCancelOrderPayload]
}
