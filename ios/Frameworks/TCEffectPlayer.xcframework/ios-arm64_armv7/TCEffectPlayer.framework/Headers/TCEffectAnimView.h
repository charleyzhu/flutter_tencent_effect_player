//  Copyright © 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TCEPAnimViewDelegate.h"
#import "TCEPConstant.h"
#import "TCEffectConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 此类用于透明视频播放，播放视图View的基础类
 * This class is used for transparent video playback, the base class of the playback view View
 */
@class TCEffectAnimInfo;
TCEP_EXPORT @interface TCEffectAnimView : UIView

/**
 * 事件回调
 * event callback
 */
@property (nonatomic, weak, nullable) id<TCEPAnimViewDelegate> effectPlayerDelegate;

/**
 * 初始化RenderView对象
 *
 * @param frame View对象的Frame
 * @return 返回RenderView对象
 *
 * Initialize the RenderView object
 * -param frame Frame of View object
 * -return Return RenderView object
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 设置特效播放器的配置
 *
 * @param config  特效播放器的配置
 *
 * Configure special effects player
 * -param   config  The configuration of  special effects player
 */
- (void)setEffectPlayerConfig:(TCEffectConfig *)config;

/**
 * 播放Alpha视频（目前仅支持本地文件播放）
 * @param url 播放的视频文件地址，目前仅支持本地文件播放
 *
 * Play Alpha video (currently only supports local file playback)
 * -param url The video file address to be played. Currently, only local file playback is supported.
 */
- (void)startPlay:(NSString *)url;

/**
 * 设置播放是否支持循环播放
 * @param loop  循环播放的标志，YES为循环播放  NO为非循环  默认为NO
 *
 * Set whether player supports loop playback
 * -param loop is the flag for loop playback, YES means loop playback, NO means non-loop playback, and the default is NO.
 */
- (void)setLoop:(BOOL)loop;

/**
 * 停止播放音视频流
 * Stop playing audio and video streams
 */
- (void)stopPlay;

/**
 * 是否正在播放
 * is playing
 */
- (BOOL)isPlaying;

/**
 * 暂停播放
 * Pause playback
 */
- (void)pause;

/**
 * 继续播放
 * resume playing
 */
- (void)resume;

/**
 * 播放跳转到音视频流某个时间
 * @param time 起始播放的时间
 *
 * * Playback jumps to a certain time in the audio and video stream
 * -param time time to start playing
 */
- (void)seek:(float)time;

/**
 * 设置画面的方向
 * @param rotation 画面方向, 默认为‘TCEP_HOME_ORIENTATION_DOWN’ 模式
 *
 * Set the screen orientation, default value is ‘TCEP_HOME_ORIENTATION_DOWN’
 * -param rotation screen direction
 */
- (void)setRenderRotation:(TCEP_Enum_Type_HomeOrientation)rotation;

/**
 * 设置画面的裁剪模式
 * @param renderMode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边），默认值TCEPVPViewContentModeAspectFit
 *
 * Set the cropping mode of the screen
 * -param renderMode fill (the picture may be stretched and cropped) or adapt (the picture may have black edges), default value TCEPVPViewContentModeAspectFit
 */
- (void)setRenderMode:(TCEPVPViewContentMode)renderMode;

/**
 * 设置静音
 * @param bEnable 设置是否为静音
 *
 * Set mute
 * -param bEnable Set whether to mute
 */
- (void)setMute:(BOOL)bEnable;

/**
 * 设置播放速率
 * @param rate 播放速度（0.5-2.0）
 *
 * Set playback rate
 * -param rate playback speed (0.5-2.0)
 */
- (void)setRate:(float)rate;

/**
 * 设置 Alpha素材中每一帧Alpha通道数据的位置
 * @param mode Alpha通道数据的位置
 *
 * Set the position of the Alpha channel data of each frame in the Alpha material
 * -param mode Alpha channel data location
 */
- (void)setVideoMode:(TCEPVAPVideoFrameTextureBlendMode)mode;

/**
 * 获取动画文件的信息，此接口需要在动画开始播放后获取才有效
 * @return 返回当前播放的动画文件信息
 *
 * Get the information of the animation file. This interface is only valid after the animation starts playing.
 * -return  Returns the information of the currently playing animation file
 */
- (nullable TCEffectAnimInfo *)getAnimInfo;

/**
 * 返回View的Frame
 * @return 返回View的Frame
 *
 * Return the Frame of View
 * -return Returns the Frame of View
 */
- (CGRect)viewFrame;

/**
 * 返回View的Size大小
 * @return 返回View的Size
 *
 * Returns the Size of the View
 * -return Returns the Size of View
 */
- (CGSize)viewSize;

/**
 *  获取SDK的版本
 *  @return 返回SDK的版本
 *
 * Get the SDK version info.
 */
+ (NSString *)getSdkVersion;

@end

NS_ASSUME_NONNULL_END
