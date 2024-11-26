/**
 * @Author: Charley
 * @Description: 特效动画视图相关常量
 */

/// TCEffectAnimView 播放器事件通知
#define kCallbackMethodTCEffectAnimViewEvent @"TCEffectAnimViewEventCallback"

/// TCEffectAnimView 替换融合动画资源配置中的文本占位符
#define kCallbackMethodTextContentForPlayer @"TextContentForPlayerCallback"

/// TCEffectAnimView 替换融合动画资源配置中的文本占位符， 支持配置文件的对齐方式、颜色等属性。
#define kCallbackMethodLoadTextForPlayer @"LoadTextForPlayerCallback"

/// TCEffectAnimView 传入融合动画资源中的图片信息
#define kCallbackMethodLoadImageForPlayer @"LoadImageForPlayerCallback"

/// TCEffectAnimView 融合动画资源点击事件回调
#define kCallbackMethodTCEffectAnimViewClickEvent @"TCEffectAnimViewClickEventCallback"

/// TCEffectAnimView 融合动画开始播放回调
#define kCallbackMethodTCEffectAnimViewStart @"TCEffectAnimViewStartCallback"

/// TCEffectAnimView 融合动画结束播放回调
#define kCallbackMethodTCEffectAnimViewEnd @"TCEffectAnimViewEndCallback"

/// TCEffectAnimView 融合动画播放错误回调
#define kCallbackMethodTCEffectAnimViewError @"TCEffectAnimViewErrorCallback"

/// 初始化视图
#define kCallbackMethodInitPlayerView @"method_initPlayerView"

/// 播放视频
#define kCallbackMethodPlayWithUrl @"method_playWithUrl"

/// 播放路径
#define kCallbackMethodPlayWithPath @"method_playWithPath"

/// 播放资源
#define kCallbackMethodPlayWithAsset @"method_playWithAsset"

/// 暂停播放
#define kCallbackMethodPause @"method_pause"

/// 继续播放
#define kCallbackMethodResume @"method_resume"

/// 停止播放
#define kCallbackMethodStop @"method_stop"

/// 设置静音
#define kCallbackMethodSetMute @"method_setMute"

/// 设置循环
#define kCallbackMethodSetLoop @"method_setLoop" 