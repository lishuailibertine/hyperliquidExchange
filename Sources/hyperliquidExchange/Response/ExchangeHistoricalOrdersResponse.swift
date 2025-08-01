//
//  ExchangeHistoricalOrdersResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//
import Foundation
/// 历史订单模型，表示用户在某个时间点提交的订单详情
public struct ExchangeHistoricalOrderModel: Decodable {
    /// 交易币种，例如 "SOL"、"BTC"
    public var coin: String
    /// 订单方向：买入 buy / 卖出 sell
    public var side: String
    /// 限价单价格（字符串形式，通常为 USD 价格）
    public var limitPx: String
    /// 当前剩余未成交数量（也可能是委托量，单位根据合约设定）
    public var sz: String
    /// 订单唯一 ID（可能是整型数字）
    public var oid: Int
    /// 下单时间戳（单位毫秒）
    public var timestamp: Int
    /// 触发条件，如 ">="、"<="，适用于条件单（trigger order）
    public var triggerCondition: String
    /// 是否为触发单（条件单），true 表示该订单是由触发价格激活
    public var isTrigger: Bool
    /// 条件触发价格，仅对触发单有效
    public var triggerPx: String
    /// 是否为持仓的止盈止损单（true 表示该订单为持仓自动挂出）
    public var isPositionTpsl: Bool
    /// 是否为只减仓订单（true 表示不能增加持仓，只能减少）
    public var reduceOnly: Bool
    /// 订单类型：如 "limit"（限价单）、"market"（市价单）、"postOnly"、"ioc" 等
    public var orderType: String
    /// 原始下单数量（一般大于或等于 `sz`，表示总挂单数量）
    public var origSz: String
    /// Time-In-Force 策略，如：
    /// - "GTC"（Good Till Cancel，挂到取消）
    /// - "IOC"（Immediate Or Cancel，立即成交否则取消）
    /// - "FOK"（Fill Or Kill）
    /// - "FrontendMarket"（前端构造的市价单特殊标记）
    public var tif: String
}

public enum ExchangeHistoricalOrdersStatus: Decodable, Equatable {
    case filled // 订单已完全成交
    case open // 订单已创建，但尚未成交或未全部成交
    case canceled // 订单被用户或系统取消，未全部成交
    case triggered // 条件订单已触发，但未必成交
    case rejected // 下单失败，未被接受
    case marginCanceled //爆仓?
    case unknown(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw {
        case "filled":
            self = .filled
        case "open":
            self = .open
        case "canceled":
            self = .canceled
        case "triggered":
            self = .triggered
        case "rejected":
            self = .rejected
        case "marginCanceled":
            self = .marginCanceled
        default:
            self = .unknown(raw)
        }
    }
}

public struct ExchangeHistoricalOrdersResponse: Decodable {
    public var order: ExchangeHistoricalOrderModel
    public var status: ExchangeHistoricalOrdersStatus
    public var statusTimestamp: Int
}
