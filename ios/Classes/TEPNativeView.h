/*
 * @Author: Charley
 * @Date: 2024-11-09 11:38:46
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/ios/Classes/TEPNativeView.h
 * @LastEditTime: 2024-11-09 16:08:12
 * @LastEditors: Charley
 */
//
//  TEPNativeView.h
//  tencent_effect_player
//
//  Created by Charley on 9/11/2024.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <TCEffectPlayer/TCEffectPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end

@interface TEPNativeView : NSObject <FlutterPlugin,FlutterPlatformView,TCEPAnimViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar;

- (UIView *)view;
@end

NS_ASSUME_NONNULL_END
