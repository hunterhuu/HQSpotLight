//
//  HQFileManager.h
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQFileManager : NSObject

//  创建文件
+ (BOOL)creatFileWithPath:(NSString *)filePath;
//  创建文件夹
+ (BOOL)creatDirectoryWithPath:(NSString *)filePath;
//  清理文件夹
+ (BOOL)clearDirectoryWithPath:(NSString *)filePath;
//  删除文件
+ (BOOL)removeFileOrDirectoryWithPath:(NSString *)filePath;
//  移动文件
+ (BOOL)moveFileFromPath:(NSString *)fromFilePath toPath:(NSString *)toFilePath;

//  获取路径
+ (NSString *)getAppPath;
+ (NSString *)getAppDocumentPath;
+ (NSString *)getAppLibraryPath;
+ (NSString *)getAppCachePath;

@end
