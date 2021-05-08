//
//  ZJJFormExtension.swift
//  ZJJForm
//
//  Created by weiqu on 2021/4/23.
//

import UIKit
import Foundation

extension String {
    // MARK: - 验证邮箱
    func verifyEmail() -> Bool  {
        return self.verifyRegex(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    //验证长度
    func verfiyLength(min:Int,max:Int) -> Bool {
        if min > max {
            return false
        }
       return self.verifyRegex(of: "^.{\(min),\(max)}$")
    }
    
    //验证正则表达
    func verifyRegex(of regex:String) -> Bool {
        if self.count == 0 {
            return false
        }
        let regexPredicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexPredicate.evaluate(with: self)
    }
    
    func formateForBankCard() -> String {
        return self.format(of: " ", sliceLength: 4)
    }
    
    /// 分组格式化
    /// - Parameter joined: 间隔字符串
    /// -sliceLength 分组的长度
    /// - Returns: 格式化好的字符串
    func format(of joined:String = " ",sliceLength:Int = 4) -> String{
        guard self.count > 0 else {
            return self
        }
        let string =  self.replacingOccurrences(of: joined, with: "")
        let length: Int = string.count
        let count: Int = length / sliceLength
        var data: [String] = []
        for i in 0..<count {
            let start: Int = sliceLength * i
            let end: Int = sliceLength * (i + 1)
            data.append(string[start..<end])
        }
        if length % sliceLength > 0 {
            data.append(string[sliceLength * count..<length])
        }
        let result = data.joined(separator: joined)
        return result
    }
    
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
}

extension NSObject {
    
    func getAllIvars()->[String]{
        
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyIvarList(object_getClass(self), count)
        let countInt = Int(count[0])
        for i in 0 ..< countInt {
            if let temp = buff?[i] {
                let tempPro = ivar_getName(temp)
                if let _ = tempPro {
                    let proper = String.init(utf8String: tempPro!)
                    if let nm = proper {
                        result.append(nm)
                    }
                }   
            }
        }
        return result

     }
    
}
