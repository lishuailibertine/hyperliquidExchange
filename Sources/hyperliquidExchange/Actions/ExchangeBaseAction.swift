//
//  ExchangeBaseAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/25.
//
public protocol ExchangeBaseAction: ExchangeEncodePaload{
    var type: String { get }
}
