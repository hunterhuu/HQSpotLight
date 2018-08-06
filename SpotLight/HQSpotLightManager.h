//
//  HQSpotLightManager.h
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HQSpotLightItem;
@interface HQSpotLightManager : NSObject

+ (instancetype) shareInstance;
- (void)addSpotLightWithDataDict:(NSDictionary *)dataDict;
- (void)addSpotLightWithDataItem:(HQSpotLightItem *)dataItem;

@end


@interface HQSpotLightItem : NSObject

@property (nonatomic, copy) NSString *spotLightIdentifier;
@property (nonatomic, copy) NSDate *spotLightExpirationDate;

@property (nonatomic, copy) NSString *spotLightTitle;
@property (nonatomic, copy) NSString *spotLightDescription;
@property (nonatomic, copy) NSString *spotLightIconDownloadURL;
@property (nonatomic, copy) NSString *spotLightIconName;

@property (nonatomic, copy) NSArray <NSString *>*spotLightKeywords;

@end

