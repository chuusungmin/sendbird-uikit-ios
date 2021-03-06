//
//  SBUGlobalCustomParams.swift
//  SendBirdUIKit
//
//  Created by Tez Park on 2020/09/09.
//  Copyright © 2020 SendBird, Inc. All rights reserved.
//

import UIKit

@objcMembers
public class SBUGlobalCustomParams: NSObject {
    
    /// This is a builder that allows you to predefined the global `SBDGroupChannelParams` processing to be used when creating a channel.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.groupChannelParamsCreateBuilder = { params in
    ///     params?.isDistinct = true
    ///     ...
    /// }
    /// ```
    public static var groupChannelParamsCreateBuilder:((_ params: SBDGroupChannelParams?) -> Void)? = nil
    
    /// This is a builder that allows you to predefined the global `SBDGroupChannelParams` processing to be used when updating a channel.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.groupChannelParamsUpdateBuilder = { params in
    ///     params?.coverUrl = <URL_PATH>
    ///     ...
    /// }
    /// ```
    public static var groupChannelParamsUpdateBuilder:((_ params: SBDGroupChannelParams?) -> Void)? = nil
    
    
    /// This is a builder that allows you to predefined the global `SBDUserMessageParams` processing to be used when sending a user message.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.userMessageParamsSendBuilder = { params in
    ///     params?.customType = <TYPE>
    ///     ...
    /// }
    /// ```
    public static var userMessageParamsSendBuilder:((_ params: SBDUserMessageParams?) -> Void)? = nil
    
    /// This is a builder that allows you to predefined the global `SBDUserMessageParams` processing to be used when updating a user message.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.userMessageParamsUpdateBuilder = { params in
    ///     params?.message = <MESSAGE>
    ///     ...
    /// }
    /// ```
    public static var userMessageParamsUpdateBuilder:((_ params: SBDUserMessageParams?) -> Void)? = nil
    
    /// This is a builder that allows you to predefined the global `SBDFileMessageParams` processing to be used when sending a file message.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.fileMessageParamsSendBuilder = { params in
    ///     params?.fileUrl = <FILE_URL>
    ///     ...
    /// }
    /// ```
    public static var fileMessageParamsSendBuilder:((_ params: SBDFileMessageParams?) -> Void)? = nil

    
    /// This is a builder that allows you to predefined the global `SBDMessageListParams` processing to be used when loading message list.
    ///
    /// - Important:
    /// This value is ignored if you set the parameter value directly through functions that receive the parameter inside the class.
    ///
    /// See the example below for builder setting.
    /// ```
    /// SBUGlobalCustomParams.messageListParamsBuilder = { params in
    ///     params?.includeReactions = true
    ///     params?.includeReplies = true
    ///     ...
    /// }
    /// ```
    public static var messageListParamsBuilder:((_ params: SBDMessageListParams?) -> Void)? = nil
}
