//
//  ExchangeSignature.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/29.
//
import Foundation

public struct ExchangeSignature: ExchangeEncodePayload, Encodable{
    public var r: String
    public var s: String
    public var v: Int
    public init(r: String, s: String, v: Int) {
        self.r = r
        self.s = s
        self.v = v
    }
    static func parseSignatureHex(_ signatureHex: String) throws -> ExchangeSignature {
        guard signatureHex.count == 130 else {
            throw ExchangeSignError.signError
        }
        let rHex = String(signatureHex.prefix(64))
        let sHex = String(signatureHex.dropFirst(64).prefix(64))
        let vHex = String(signatureHex.suffix(2))
        guard let vInt = Int(vHex, radix: 16) else {
            throw ExchangeSignError.signError
        }
        return ExchangeSignature(r: "0x" + rHex, s: "0x" + sHex, v: vInt)
    }
    
    public func signatureData() -> Data? {
        let rClean = self.r.hasPrefix("0x") ? String(self.r.dropFirst(2)) : self.r
        let sClean = self.s.hasPrefix("0x") ? String(self.s.dropFirst(2)) : self.s
        guard rClean.count == 64, sClean.count == 64 else {
            return nil
        }
        guard self.v >= 0 && self.v <= 255 else {
            return nil
        }
        var result = Data()
        result.append(Data(hex: rClean))
        result.append(Data(hex: sClean))
        result.append(UInt8(self.v))
        return result
    }
    
    var description: String {
        return """
        R:
                \(self.r)
        S:
                \(self.s)
        V:
                \(self.v)
        """
    }
}
