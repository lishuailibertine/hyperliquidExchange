//
//  ExchangeClearinghouseStateResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//
import Foundation
/// 清算状态响应体
public struct ExchangeClearingStateResponse: Decodable {
    /// 当前账户的逐仓保证金汇总信息
    public var marginSummary: ExchangeClearingMarginSummary
    /// 当前账户的全仓保证金汇总信息
    public var crossMarginSummary: ExchangeClearingMarginSummary
    /// 当前全仓持仓的维持保证金使用量（通常为总持仓风险指标）
    public var crossMaintenanceMarginUsed: String
    /// 可提取余额（可能扣除已用保证金、未实现盈亏等）
    public var withdrawable: String
    /// 当前所有持仓（按资产列出）
    public var assetPositions: [ExchangeClearingAssetPosition]
    /// 服务端记录的时间戳（毫秒）
    public var time: Int64
}

/// 保证金汇总信息（适用于逐仓和全仓）
public struct ExchangeClearingMarginSummary: Decodable {
    /// 当前账户总权益（包括已实现盈亏、未实现盈亏等）
    public var accountValue: String
    /// 总名义持仓量（例如合约乘以价格）
    public var totalNtlPos: String
    /// 总 USD 名义价值（可能是持仓方向相关的原始值）
    public var totalRawUsd: String
    /// 当前已使用的保证金（不包括浮盈）
    public var totalMarginUsed: String
}

/// 单个资产持仓信息
public struct ExchangeClearingAssetPosition: Decodable {
    /// 持仓类型：如 `oneWay` 表示单向持仓
    public var type: String
    /// 具体持仓详情
    public var position: ExchangeClearingPositionDetail
}

/// 持仓详情
public struct ExchangeClearingPositionDetail: Decodable {
    /// 币种，例如 "SOL"、"BTC"
    public var coin: String
    /// 持仓数量（以合约单位或 token 数量计）
    public var szi: String
    /// 杠杆信息
    public var leverage: ExchangeClearingLeverage
    /// 持仓开仓价格
    public var entryPx: String
    /// 当前持仓价值（名义价值）
    public var positionValue: String
    /// 当前未实现盈亏（USD）
    public var unrealizedPnl: String
    /// 当前持仓的账户回报率（ROE），小数值如 0.25 表示 25%
    public var returnOnEquity: String
    /// 当前持仓的强平价格（清算价格）
    public var liquidationPx: String
    /// 当前持仓占用的保证金（逐仓或全仓）
    public var marginUsed: String
    /// 当前该品种允许的最大杠杆倍数
    public var maxLeverage: Int
    /// 累计资金费信息
    public var cumFunding: ExchangeClearingCumFunding
}

/// 杠杆信息结构
public struct ExchangeClearingLeverage: Decodable {
    /// 杠杆类型，例如 "isolated"（逐仓）或 "cross"（全仓）
    public var type: String
    /// 杠杆倍数，如 20 表示 20x 杠杆
    public var value: Int
}

/// 累计资金费信息
public struct ExchangeClearingCumFunding: Decodable {
    /// 开仓以来的累计资金费
    public var allTime: String
    /// 当前持仓开仓以来的资金费
    public var sinceOpen: String
    /// 上次加仓或调仓以来的资金费
    public var sinceChange: String
}
