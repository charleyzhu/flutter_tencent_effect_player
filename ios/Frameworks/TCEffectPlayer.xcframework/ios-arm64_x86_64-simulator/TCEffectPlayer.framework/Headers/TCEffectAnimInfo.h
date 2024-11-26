// Copyright (c) 2021 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TCEPConstant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 动画文件的 Animation 信息
 * The file info of animation file
 */

TCEP_EXPORT @interface TCEffectAnimInfo : NSObject

/**
 * 资源类型
 * Animation  resource type
 */
@property (nonatomic, assign) TCEPAnimResourceType resType;

/**
 * 视频资源的时长，单位ms
 * The duration of the video resource, in ms
 */
@property (nonatomic, assign) long duration;

/**
 * 播放资源的视频宽度
 * The width of  animation  resource
 */
@property (nonatomic, assign) int width;

/**
 * 播放资源的视频高度
 * The height of  animation  resource
 */
@property (nonatomic, assign) int height;

@end

NS_ASSUME_NONNULL_END
