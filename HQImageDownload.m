//
//  HQImageDownload.m
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "HQImageDownload.h"

@interface HQImageDownload()

@property (nonatomic, strong) NSURLSession* downloadSession;
@property (nonatomic, strong) NSMutableArray <NSURLSessionDownloadTask *>*downloadTaskArray;

@end

@implementation HQImageDownload

static HQImageDownload* _shareInstance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] initMethod] ;
    });
    
    return _shareInstance ;
}

- (instancetype)initMethod {
    self = [super init];
    if (self) {
        self.downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.downloadTaskArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)cancelAllTask {
    for (NSURLSessionDownloadTask *downloadTask in self.downloadTaskArray) {
        [downloadTask cancel];
    }
    [self.downloadTaskArray removeAllObjects];
}

- (void)downLoadImageWithURLString:(NSString *)URLString completionHandler:(void (^)(NSURLSessionDownloadTask *downloadTask ,NSString *downloadImageURLString, NSError *error))completionHandler{
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask* downloadTask;
    __block typeof(completionHandler) blockCompletionHandler = completionHandler;
    __weak typeof(downloadTask) weakDownloadTask = downloadTask;
    __weak typeof(self) weakSelf = self;
    downloadTask = [self.downloadSession downloadTaskWithRequest:downloadRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *tempDownLoadImageURLString;
        if ([location.absoluteString hasPrefix:@"file://"]) {
            tempDownLoadImageURLString = [location.absoluteString substringFromIndex:7];
        } else {
            tempDownLoadImageURLString = location.absoluteString;
        }
        if (blockCompletionHandler) {
            blockCompletionHandler(weakDownloadTask, tempDownLoadImageURLString, error);
        }
        [weakSelf.downloadTaskArray removeObject:weakDownloadTask];
    }];
    [downloadTask resume];
    [self.downloadTaskArray addObject:downloadTask];
}


@end
