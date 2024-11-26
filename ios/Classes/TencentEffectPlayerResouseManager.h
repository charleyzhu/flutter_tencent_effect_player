//
//  TencentEffectPlayerResouseManager.h
//  tencent_effect_player
//
//  Created by Charley on 11/11/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TencentEffectPlayerResouseManager : NSObject

/// 获取资源路径
+ (void)getResourcePathWithUrl:(NSString *)url completionHandler:(void (^)(NSString *path, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
