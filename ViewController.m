//
//  ViewController.m
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "ViewController.h"
#import "HQSpotLightManager.h"

#import "HQFileManager.h"
#import "HQImageDownload.h"

@interface ViewController ()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *tempDict = @{
                               @"spotLightIdentifier":@"id",
                               @"spotLightTitle":@"title",
                               @"spotLightDescription":@"description",
                               @"spotLightIconDownloadURL":@"https://p1.ssl.qhmsg.com/dr/220__/t011aff00fb16d55ec7.png",
                               @"spotLightKeywords":@[@"keywords"],
                               
                               };
    
    [[HQSpotLightManager shareInstance] addSpotLightWithDataDict:tempDict];
    
//    NSLog(@"%@", [HQFileManager getAppDocumentPath]);
//    NSLog(@"%@", [HQFileManager getAppLibraryPath]);
//    NSLog(@"%@", [HQFileManager getAppCachePath]);
//    NSLog(@"%@", [HQFileManager getAppPath]);
//    NSString* path = [NSString stringWithFormat:@"%@/text/image", [HQFileManager getAppDocumentPath]];
//    [HQFileManager clearDirectoryWithPath:path];
//    self.downloadTask = [[HQImageDownload shareInstance] downLoadImageWithURLString:@"https://b-ssl.duitang.com/uploads/item/201508/09/20150809005334_rxVJH.jpeg" completionHandler:^(NSURLSessionDownloadTask *downloadTask, NSString *downloadImageURLString, NSError *error) {
//
//        [HQFileManager moveFileFromPath:downloadImageURLString toPath:path];
//
//    }];

}

- (void)initMethod {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
