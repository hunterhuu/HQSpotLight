//
//  HQFileManager.m
//  HQSpotlight
//
//  Created by huqi on 2018/7/10.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "HQFileManager.h"

@implementation HQFileManager

+ (BOOL)creatFileWithPath:(NSString *)filePath{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        [HQFileManager removeFileOrDirectoryWithPath:filePath];
    }
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [HQFileManager creatDirectoryWithPath:dirPath];
    }
    if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
        return YES;
    } else {
        NSLog(@"creat File Error");
        return NO;
    }
}

+ (BOOL)creatDirectoryWithPath:(NSString *)filePath {

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"creat Directory Error %@",error.localizedDescription);
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

+ (BOOL)clearDirectoryWithPath:(NSString *)filePath {
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
        NSLog(@"clear Directory Error");
        return NO;
    }
    [self removeFileOrDirectoryWithPath:filePath];
    [self creatDirectoryWithPath:filePath];
    
    return YES;
}


+ (BOOL)removeFileOrDirectoryWithPath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
            return YES;
        } else {
            NSLog(@"remove File Error %@", error.localizedDescription);
            return NO;
        }
    }
    return YES;
}

+ (BOOL)moveFileFromPath:(NSString *)fromFilePath toPath:(NSString *)toFilePath {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:fromFilePath toPath:toFilePath error:&error];
    if (error) {
        NSLog(@"moveFile Error %@", error.description);
        return NO;
    }
    
    return YES;
}

+ (NSString *)getAppPath
{
    return NSHomeDirectory();
}

+ (NSString *)getAppDocumentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)getAppLibraryPath
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)getAppCachePath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}


@end
