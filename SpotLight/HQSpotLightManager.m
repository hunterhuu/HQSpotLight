//
//  HQSpotLightManager.m
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "HQSpotLightManager.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <CommonCrypto/CommonDigest.h>


@interface HQSpotLightManager()

@property (nonatomic, strong) NSURLSession* downloadSession;
@property (nonatomic, strong) NSMutableArray <NSURLSessionDownloadTask *>*downloadTaskArray;

@end

@implementation HQSpotLightManager

static HQSpotLightManager* _shareInstance = nil;
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
        BOOL isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self getSoptLightIconImageDirPath] isDirectory:&isDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[self getSoptLightIconImageDirPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (void)addSpotLightWithDataDict:(NSDictionary *)dataDict {
    HQSpotLightItem *dataItem = [[HQSpotLightItem alloc] init];
    [dataItem setValuesForKeysWithDictionary:dataDict];
    [self addSpotLightWithDataItem:dataItem];
}

- (void)addSpotLightWithDataItem:(HQSpotLightItem *)dataItem {
    
    CSSearchableItemAttributeSet *attset = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
    attset.title = dataItem.spotLightTitle;
    attset.contentDescription = dataItem.spotLightDescription;
    attset.keywords = dataItem.spotLightKeywords;

    if (dataItem.spotLightIconName != nil && dataItem.spotLightIconName.length > 0) {
        //本地boundl图片
        if ([dataItem.spotLightIconName hasPrefix:@"url://"]) {
            if ([dataItem.spotLightIconDownloadURL hasSuffix:@".jpeg"]) {
                attset.thumbnailData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[dataItem.spotLightIconName substringFromIndex:6]], 1);
            } else {
                attset.thumbnailData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[dataItem.spotLightIconName substringFromIndex:6]]);
            }
            NSLog(@"gogo");
        } else {
            attset.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:dataItem.spotLightIconName]);
        }
    } else if (dataItem.spotLightIconDownloadURL != nil && dataItem.spotLightIconDownloadURL.length > 0){
        
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[self getSoptLightIconImageDirPath] ,[self md5:dataItem.spotLightIconDownloadURL]];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath isDirectory:&isDir]) {
            dataItem.spotLightIconName = [NSString stringWithFormat:@"url://%@", toPath];
            [self addSpotLightWithDataItem:dataItem];
            return;
        } else {
            __block typeof(dataItem)blockDataItem = dataItem;
            __weak typeof(self) weakSelf = self;
            [self downLoadImageWithURLString:dataItem.spotLightIconDownloadURL completionHandler:^(NSURLSessionDownloadTask *downloadTask, NSString *downloadImageURLString, NSError *error) {
                if (!error && (blockDataItem != nil)) {
                    [[NSFileManager defaultManager] moveItemAtPath:downloadImageURLString toPath:toPath error:nil];
                    dataItem.spotLightIconName = [NSString stringWithFormat:@"url://%@", toPath];
                    [weakSelf addSpotLightWithDataItem:dataItem];
                    return ;
                }
                
            }];
            //站位图
//            attset.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"text"]);
        }
    }
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:dataItem.spotLightIdentifier domainIdentifier:@"domainIdentifier" attributeSet:attset];
    if (dataItem.spotLightExpirationDate != nil) {
        item.expirationDate = dataItem.spotLightExpirationDate;
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

#pragma mark -

- (NSString *)getSoptLightIconImageDirPath {
    return [NSString stringWithFormat:@"%@/SpotLightImageDIR", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
}

#pragma mark -
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

- (BOOL)moveFileFromPath:(NSString *)fromFilePath toPath:(NSString *)toFilePath {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:fromFilePath toPath:toFilePath error:&error];
    if (error) {
        NSLog(@"moveFile Error %@", error.description);
        return NO;
    }
    return YES;
}

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return  output;
}

@end

@implementation HQSpotLightItem

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
    
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
