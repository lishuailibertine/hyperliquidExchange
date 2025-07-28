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
    public init(isMarket: Bool, triggerPx: String, tpsl: ExchangeTpslType) {
        self.isMarket = isMarket
        self.triggerPx = triggerPx
        self.tpsl = tpsl
    }
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

public enum ExchangeOrderType: ExchangeEncodePayload, Encodable {
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

public struct ExchangePlaceOrderPayload: ExchangeEncodePayload, Encodable {
    public var a: Int // asset
    public var b: Bool // isBuy
    public var p: String // price
    public var r: Bool // reduceOnly
    public var s: String // size
    public var t: ExchangeOrderType // type
    public init(a: Int, b: Bool, p: String, r: Bool, s: String, t: ExchangeOrderType) {
        self.a = a
        self.b = b
        self.p = p
        self.r = r
        self.s = s
        self.t = t
    }
}

public struct ExchangePlaceOrderAction: ExchangeBaseAction, Encodable{
    public var type: String
    public var orders: [ExchangePlaceOrderPayload]
    public var grouping: ExchangeOrderGroupingType
    public init(type: String = "order", orders: [ExchangePlaceOrderPayload], grouping: ExchangeOrderGroupingType) {
        self.type = type
        self.orders = orders
        self.grouping = grouping
    }
}

public struct ExchangeCancelOrderPayload: Encodable {
    public var a: Int // asset
    public var o: Int // is oid (order id)
    public init(a: Int, o: Int) {
        self.a = a
        self.o = o
    }
}

public struct ExchangeCancelOrderAction: ExchangeBaseAction, Encodable {
    public var type: String
    public var cancels: [ExchangeCancelOrderPayload]
    public init(type: String = "cancel", cancels: [ExchangeCancelOrderPayload]) {
        self.type = type
        self.cancels = cancels
    }
}

public struct ExchangeCancelOrderByIdPayload: Encodable {
    public var a: Int // asset
    public var cloid: String
    public init(a: Int, cloid: String) {
        self.a = a
        self.cloid = cloid
    }
}

public struct ExchangeCancelOrderByIdAction: ExchangeBaseAction, Encodable {
    public var type: String
    public var cancels: [ExchangeCancelOrderPayload]
    public init(type: String = "cancelByCloid", cancels: [ExchangeCancelOrderPayload]) {
        self.type = type
        self.cancels = cancels
    }
}
