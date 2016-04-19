//
//  NSObect+RuntimeIvar.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/4/2.
//  Copyright © 2016年 LZING. All rights reserved.
//

import Foundation

/// 返回值对应表
let ivarTypeDict = [":": "SEL", "#": "Class", "@": "id", "*": "char *", "v": "Void", "B": "Bool", "d": "Double", "f": "Float", "Q": "Long", "L": "Long", "S": "Short", "I": "Int", "C": "Char", "q": "Long", "c": "Char", "i": "Int", "s": "Short", "l": "Long"]

extension NSObject {
    class func printIvars() {
        // 保存成员变量数量
        var count : UInt32 = 0
        // 拷贝出成员变量数组
        let ivars = class_copyIvarList(self, &count)
        LZPrint(msg: "类的成员变量-----\(self)开始")
        // 遍历
        for i in 0..<count {
            // 取出数组中的元素
            let ivar = ivars[Int(i)]
            // 获取char类型的成员变量名
            let cName = ivar_getName(ivar)
            // 将char类型转换为string
            let name = String(CString: cName, encoding: NSUTF8StringEncoding)!
            // 获取成员类型
            let cType = ivar_getTypeEncoding(ivar)
            var type = String(CString: cType, encoding: NSUTF8StringEncoding)!
            if let newType = ivarTypeDict[type] {
                type = newType
            }
            LZPrint(msg: "成员变量名:\(name)---成员类型:\(type)")
        }
        LZPrint(msg: "类的成员变量-----\(self)结束")
        // 释放
        free(ivars)
    }
}