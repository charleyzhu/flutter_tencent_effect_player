//
//  TencentEffectPlayerResouseManager.m
//  tencent_effect_player
//
//  Created by Charley on 11/11/2024.
//

#import "TencentEffectPlayerResouseManager.h"
#import "constant.h"
#import "NSString+NSString_sha256.h"


@interface TencentEffectPlayerResouseManager ()
@end

@implementation TencentEffectPlayerResouseManager


+ (void)getResourcePathWithUrl:(NSString *)url completionHandler:(void (^)(NSString *path, NSError *error))handler {

    // 1. 获取缓存路径
    NSString *resourcePath = [self getResourceWithUrl:url];
    if (resourcePath) {
        // 2.1 资源存在
        handler(resourcePath, nil);
    } else {
        // 2.2 资源不存在, 下载资源
        [self downloadResourceWithUrl:url completionHandler:handler];
    }
    
}

/// 获取缓存目录路径
+ (NSString *)getCacheDirectoryPath {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    static NSString *cacheDir;
    if (!cacheDir) {
        cacheDir= [NSString stringWithFormat:@"%@/%@", cachePaths.firstObject, kCacheDir];
    }
    return cacheDir;
}
/// 初始化缓存目录
+ (void)initCacheDir {
    NSString *cacheDir = [self getCacheDirectoryPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheDir]) {
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/// 获取资源路径,如果资源不存在,则返回nil
+ (NSString *)getResourceWithUrl:(NSString *)urlStr {
    // 获取url文件的扩展名
    NSString *extName = [urlStr pathExtension];
    NSString *keyMd5 = [urlStr sha256];
    NSString *cacheDir = [self getCacheDirectoryPath];
    NSString *resourcePath = [cacheDir stringByAppendingPathComponent:[keyMd5 stringByAppendingPathExtension:extName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
        return resourcePath;
    }
    return nil;
}


+ (void)downloadResourceWithUrl:(NSString *)urlStr completionHandler:(void (^)(NSString *path, NSError *error))handler {
    // 1. 初始化缓存目录
    [self initCacheDir];

    // 2. 下载资源
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            handler(nil, error);
        }else {
            NSString *resourcePath = nil;
            if (data) {
                resourcePath  = [self saveUrl:urlStr Data:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(resourcePath, nil);
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, [NSError errorWithDomain:@"TencentEffectPlayerResouseManager" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"下载资源失败"}]);
                });
            }
        }                           
    }];
    [dataTask resume];
}

// 保存资源 如果成功，返回资源路径
+ (NSString *)saveUrl:(NSString *)urlStr Data:(NSData *)data {
    // 获取url文件的扩展名
    NSString *extName = [urlStr pathExtension];
    NSString *cacheDir = [self getCacheDirectoryPath];
    NSString *resourcePath = [cacheDir stringByAppendingPathComponent:[[urlStr sha256] stringByAppendingPathExtension:extName]];
    BOOL success = [data writeToFile:resourcePath atomically:YES];
    if (success) {
        return resourcePath;
    }
    return nil;
}

@end
