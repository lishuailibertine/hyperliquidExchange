//
//  ExchangeOrderAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/25.
//
import Foundation
public enum ExchangeLimitOrderType: String {
    case ALO // (add liquidity only, i.e. "post only") will be canceled instead of immediately matching.
    case Ioc // (immediate or cancel) will have the unfilled part canceled instead of resting.
    case Gtc // (good til canceled) orders have no special behavior.
}

public enum ExchangeTpslType: String {
    case tp
    case sl
}

public struct ExchangeTriggerOrderType{
    public var isMarket: Bool
    public var triggerPx: String
    public var tpsl: ExchangeTpslType
}

public enum ExchangeOrderType {
    case limit(ExchangeLimitOrderType)
    case trigger(ExchangeTriggerOrderType)
}

public enum ExchangeOrderGroupingType: String{
    case na
    case normalTpsl
    case positionTpsl
}

public struct ExchangePlaceOrderPayload {
    public var a: Int // asset
    public var b: Bool // isBuy
    public var p: String // price
    public var r: Bool // reduceOnly
    public var s: String // size
    public var t: ExchangeOrderType // type
}

public struct ExchangePlaceOrderAction: ExchangeBaseAction{
    public var type: String = "order"
    public var orders: [ExchangePlaceOrderPayload]
    //
    public var grouping: ExchangeOrderGroupingType
    
    public func payload() -> [String : Any] {
        return [:]
    }
}

public struct ExchangeCancelOrderPayload {
    public var a: Int // asset
    public var o: Int // is oid (order id)
}

public struct ExchangeCancelOrderAction: ExchangeBaseAction {
    public var type: String = "cancel"
    public var cancels: [ExchangeCancelOrderPayload]
    public func payload() -> [String : Any] {
        return [:]
    }
}

public struct ExchangeCancelOrderByIdPayload {
    public var a: Int // asset
    public var cloid: String
}

public struct ExchangeCancelOrderByIdAction: ExchangeBaseAction {
    public var type: String = "cancelByCloid"
    public var cancels: [ExchangeCancelOrderPayload]
    public func payload() -> [String : Any] {
        return [:]
    }
}
