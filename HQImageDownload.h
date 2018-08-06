//
//  HQImageDownload.h
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HQImageDownload : NSObject

+ (instancetype) shareInstance;
- (void)cancelAllTask;
- (void)downLoadImageWithURLString:(NSString *)URLString completionHandler:(void (^)(NSURLSessionDownloadTask *downloadTask ,NSString *downloadImageURLString, NSError *error))completionHandler;

@end
