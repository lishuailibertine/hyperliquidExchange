//
//  ExchangeSnapshotResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//

import Foundation
public struct ExchangeSnapshotResponse: Decodable {
    public var T: Int // 结束时间戳
    public var c: String // 收盘价
    public var h: String // 最高价
    public var i: String // K线的时间周期
    public var l: String // 最低价
    public var n: Int // 该周期内的成交笔数
    public var o: String // 开盘价
    public var s: String // 交易对/币种
    public var t: Int // 开始时间戳
    public var v: String // 该周期内的成交量
}
