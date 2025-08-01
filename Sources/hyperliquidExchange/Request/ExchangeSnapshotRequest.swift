//
//  ExchangeCoinSnapshotRequest.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//
import Foundation
public struct ExchangeCoinSnapshotRequest: Encodable, ExchangeEncodePayload {
    public var coin: String // perp is name, spot is @id
    public var interval: String // 一根蜡烛时间 15m 这样子
    public var startTime: Int // epoch millis
    public var endTime: Int // epoch millis
    public init(coin: String, interval: String, startTime: Int, endTime: Int = Int(Date().timeIntervalSince1970 * 1000)) {
        self.coin = coin
        self.interval = interval
        self.startTime = startTime
        self.endTime = endTime
    }
}
