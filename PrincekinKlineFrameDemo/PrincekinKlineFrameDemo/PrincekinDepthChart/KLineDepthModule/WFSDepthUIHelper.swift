//
//  WFSDepthUIHelper.swift
//  Canonchain
//
//  Created by LEE on 7/26/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
/*
 由于在深度图和最新成交大量刷新数据是，如果滑动界面，会有明显的卡顿现象，所以采取，滑动时，不更新UI的处理方式，来解决卡顿现象
 1.本类采取单例模式
 2.接收滑动的通知，并设置一个bool值保存滑动与否
 3.编写一个block，在scrollview滑动结束后，推动深度图和最新成交UI刷新
 */
//滑动收到深度图影响的scrollview的在相应方法里面发送的通知名称
//let DepthScrollViewBeginDeceleratingNot = NSNotification.Name.init("DepthScrollViewBeginDeceleratingNot")
//let DepthScrollViewEndDeceleratingNot = NSNotification.Name.init("DepthScrollViewEndDeceleratingNot")
class WFSDepthUIHelper: NSObject {
   
}
