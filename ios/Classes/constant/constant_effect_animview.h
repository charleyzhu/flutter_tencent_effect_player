/*
 * @Author: Charley
 * @Date: 2024-11-12 10:11:24
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/ios/Classes/constant/constant_effect_animview.h
 * @LastEditTime: 2024-11-26 15:18:47
 * @LastEditors: Charley
 */
/**
 * @Author: Charley
 * @Description: 特效动画视图相关常量
 */

/// TCEffectAnimView 播放器事件通知
#define kTEPCallbackMethodTCEffectAnimViewEvent @"TCEffectAnimViewEventCallback"

/// TCEffectAnimView 替换融合动画资源配置中的文本占位符
#define kTEPCallbackMethodTextContentForPlayer @"TextContentForPlayerCallback"

/// TCEffectAnimView 替换融合动画资源配置中的文本占位符， 支持配置文件的对齐方式、颜色等属性。
#define kTEPCallbackMethodLoadTextForPlayer @"LoadTextForPlayerCallback"

/// TCEffectAnimView 传入融合动画资源中的图片信息
#define kTEPCallbackMethodLoadImageForPlayer @"LoadImageForPlayerCallback"

/// TCEffectAnimView 融合动画资源点击事件回调
#define kTEPCallbackMethodTCEffectAnimViewClickEvent @"TCEffectAnimViewClickEventCallback"

/// TCEffectAnimView 融合动画开始播放回调
#define kTEPCallbackMethodTCEffectAnimViewStart @"TCEffectAnimViewStartCallback"

/// TCEffectAnimView 融合动画结束播放回调
#define kTEPCallbackMethodTCEffectAnimViewEnd @"TCEffectAnimViewEndCallback"

/// TCEffectAnimView 融合动画播放错误回调
#define kTEPCallbackMethodTCEffectAnimViewError @"TCEffectAnimViewErrorCallback"

/// 初始化视图
#define kTEPCallbackMethodInitPlayerView @"method_initPlayerView"

/// 播放视频
#define kTEPCallbackMethodPlayWithUrl @"method_playWithUrl"

/// 播放路径
#define kTEPCallbackMethodPlayWithPath @"method_playWithPath"

/// 播放资源
#define kTEPCallbackMethodPlayWithAsset @"method_playWithAsset"

/// 暂停播放
#define kTEPCallbackMethodPause @"method_pause"

/// 继续播放
#define kTEPCallbackMethodResume @"method_resume"

/// 停止播放
#define kTEPCallbackMethodStop @"method_stop"

/// 设置静音
#define kTEPCallbackMethodSetMute @"method_setMute"

/// 设置循环
#define kTEPCallbackMethodSetLoop @"method_setLoop" 