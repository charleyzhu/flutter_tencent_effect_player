//
//  TEPNativeView.m
//  tencent_effect_player
//
//  Created by Charley on 9/11/2024.
//

#import "TEPNativeView.h"
#import "constant.h"
#import "TencentEffectPlayerResouseManager.h"
#import "UIColor+Hex.h"

@implementation FLNativeViewFactory {
    NSObject<FlutterPluginRegistrar> *_registrar;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    if (self = [super init]) {
        _registrar = registrar;
    }
    return self;
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[TEPNativeView alloc] initWithFrame:frame
                                viewIdentifier:viewId
                                     arguments:args
                                    registrar:_registrar];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@interface TEPNativeView()
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) NSString *viewId;
// 动画视图
@property (nonatomic, retain) TCEffectAnimView *alphaAnimView;
// 方法通道
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
// 自动播放
@property (nonatomic, assign) BOOL autoStart;
// 是否循环播放
@property (nonatomic, assign) BOOL isLoop;
// 播放URL
@property (nonatomic, copy) NSString *playUrl;
// 播放路径
@property (nonatomic, copy) NSString *resourcePath;
// 播放资源名称
@property (nonatomic, copy) NSString *assetName;
// 普通文本缓存
@property (nonatomic, strong) NSMutableDictionary *textContentCache;
// 特效文本缓存
@property (nonatomic, strong) NSMutableDictionary *loadTextCache;
// 加载图片缓存
@property (nonatomic, strong) NSMutableDictionary *loadImageCache;
@end

@implementation TEPNativeView

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    if (self = [super init]) {
        _registrar = registrar;
        
        _viewId = [NSString stringWithFormat:@"%lld",viewId];

        if (args[kTEPMethodArgsKeyViewId] != nil) {
            self.viewId = args[kTEPMethodArgsKeyViewId];
        }

        // 初始化缓存
        self.textContentCache = [NSMutableDictionary dictionary];
        self.loadTextCache = [NSMutableDictionary dictionary];
        self.loadImageCache = [NSMutableDictionary dictionary];

        // get args
        if (args[kTEPMethodArgsKeyAutoStart] != nil) {
            self.autoStart = [args[kTEPMethodArgsKeyAutoStart] boolValue];
        }else {
            self.autoStart = YES;
        }

        if (args[kTEPMethodArgsKeyIsLoop] != nil) {
            self.isLoop = [args[kTEPMethodArgsKeyIsLoop] boolValue];
        } else {
            self.isLoop = NO;
        }

        if (![args[kTEPMethodArgsKeyPlayUrl] isKindOfClass:[NSNull class]]) {
            self.playUrl = args[kTEPMethodArgsKeyPlayUrl];
        }
        
        if (![args[kTEPMethodArgsKeyResourcePath] isKindOfClass:[NSNull class]]) {
            self.resourcePath = args[kTEPMethodArgsKeyResourcePath];
        }
        
        if (![args[kTEPMethodArgsKeyAssetName] isKindOfClass:[NSNull class]]) {
            self.assetName = args[kTEPMethodArgsKeyAssetName];
        }

        // 初始化视图
        [self setupViewWithFrame:frame];

        [self setupMethodChannelWithViewId:[NSString stringWithFormat:@"%lld", viewId] registrar:registrar];
        
    }
    return self;
}


#pragma mark - Public Play Methods

- (void)playPath:(NSString *)path isOtherCall:(BOOL)isOtherCall {
    if (!isOtherCall) {
        self.resourcePath = path;
        self.playUrl = nil;
        self.assetName = nil;
    }
    [self.alphaAnimView startPlay:path];
}

- (void)playUrl:(NSString *)url {

    if (url != nil && url.length > 0) {
        self.playUrl = url;
        self.resourcePath = nil;
        self.assetName = nil;
        [TencentEffectPlayerResouseManager getResourcePathWithUrl:url completionHandler:^(NSString *path, NSError *error) {
            if (error == nil) {
                [self playPath:path isOtherCall:YES];
            }
        }];
    }
}

- (void)playAsset:(NSString *)asset {
    self.assetName = asset;
    self.resourcePath = nil;
    self.playUrl = nil;
    NSString *resourcePath = [_registrar lookupKeyForAsset:asset];
    resourcePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:nil];
    if (resourcePath == nil) {
        return;
    }
    [self playPath:resourcePath isOtherCall:YES];
}

#pragma mark - Setup Methods

- (void)setupViewWithFrame:(CGRect)frame {
    // 创建容器视图
    self.containerView = [[UIView alloc] initWithFrame:frame];
    self.containerView.backgroundColor = [UIColor clearColor];
    
    // 添加并配置动画视图
    [self.containerView addSubview:self.alphaAnimView];
    self.alphaAnimView.frame = self.containerView.bounds;
    self.alphaAnimView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

- (void)setupMethodChannelWithViewId:(NSString *)viewId registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    NSString *channelName = [NSString stringWithFormat:@"%@%@", kChannelNamePrefix, viewId];
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:channelName
                                                   binaryMessenger:registrar.messenger];
    [registrar addMethodCallDelegate:self channel:self.methodChannel];
}

#pragma mark - Getter Methods
- (TCEffectAnimView *)alphaAnimView {
    if (!_alphaAnimView) {
        _alphaAnimView = [[TCEffectAnimView alloc] init];
        _alphaAnimView.backgroundColor = [UIColor clearColor];
        _alphaAnimView.effectPlayerDelegate = self;
        _alphaAnimView.loop = self.isLoop;
        [_alphaAnimView setRenderMode:TCEPVPViewContentModeScaleToFill];
    }
    return _alphaAnimView;
}

- (UIView *)view {
    return self.containerView;
}

- (void)loadCacheData:(void(^)(void))completion {
    // 创建调度组
    dispatch_group_t group = dispatch_group_create();
    // 创建串行队列确保线程安全
    dispatch_queue_t queue = dispatch_queue_create("com.tep.cache.queue", DISPATCH_QUEUE_SERIAL);
    
    // 加载普通文本缓存
    dispatch_group_enter(group);
    NSDictionary *args = @{
        kTEPMethodArgsKeyViewId: self.viewId
    };
    [self.methodChannel invokeMethod:kTEPCallbackMethodTextContentForPlayer
                         arguments:args 
                           result:^(id _Nullable result) {
        dispatch_async(queue, ^{
            // NSLog(@"加载普通文本缓存");
            if (result != nil) {
                NSArray<NSDictionary *> *textList = result;
                if (textList != nil && textList.count > 0) {
                    for (NSDictionary *textInfo in textList) {
                        self.textContentCache[textInfo[kTEPMethodArgsKeyTag]] = textInfo[kTEPMethodArgsKeyText];
                    }
                }
            } 
            dispatch_group_leave(group);
        });
    }];

    // 加载特效文本缓存
    dispatch_group_enter(group);
    [self.methodChannel invokeMethod:kTEPCallbackMethodLoadTextForPlayer
                         arguments:args 
                           result:^(id _Nullable result) {
        dispatch_async(queue, ^{
            // NSLog(@"加载特效文本缓存");
            if (result != nil) {
                NSArray<NSDictionary *> *textList = result;
                if (textList != nil && textList.count > 0) {
                    for (NSDictionary *textInfo  in textList) {
                        NSString *tag = textInfo[kTEPMethodArgsKeyTag];
                        NSString *text = textInfo[kTEPMethodArgsKeyText];
                        BOOL isBold = [textInfo[kTEPMethodArgsKeyIsBold] boolValue];
                        NSNumber *alignmentNumber = textInfo[kTEPMethodArgsKeyAlignment];
                        NSString *colorStr = textInfo[kTEPMethodArgsKeyTextColor];
                       
                        TCEffectText *tcText = [[TCEffectText alloc] init];
                        tcText.text = text;
                        if (isBold) {
                            tcText.fontStyle = @"bold";
                        }
                        
                        if (alignmentNumber != nil) {
                            tcText.alignment = alignmentNumber.intValue;
                        }

                        if (colorStr != nil) {
                            // colorStr hex to UIColor
                            UIColor *color = [UIColor colorWithHexString:colorStr];
                            tcText.color = color;
                        }
                        self.loadTextCache[tag] = tcText;
                    }
                }
            }
            dispatch_group_leave(group);
        });
    }];

    // 加载图片缓存
    dispatch_group_enter(group);
    [self.methodChannel invokeMethod:kTEPCallbackMethodLoadImageForPlayer
                         arguments:args 
                           result:^(id _Nullable result) {
        dispatch_async(queue, ^{
            // NSLog(@"加载图片缓存");
            if (result != nil) {
                NSArray<NSDictionary *> *imageList = result;
                if (imageList != nil && imageList.count > 0) {
                    for (NSDictionary *imageInfo in imageList) {
                        NSString *tag = imageInfo[kTEPMethodArgsKeyTag];
                        self.loadImageCache[tag] = imageInfo;
                    }
                }
            } 
            dispatch_group_leave(group);
        });
    }];

    // 所有任务完成后在主线程执行回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

#pragma mark - Flutter Method Channel

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    if ([kTEPCallbackMethodInitPlayerView isEqualToString:call.method]) {
        [self handleInitPlayerView:arguments result:result];
    } else if ([kTEPCallbackMethodPlayWithUrl isEqualToString:call.method]) {
        [self handlePlayWithUrl:arguments result:result];
    } else if ([kTEPCallbackMethodPlayWithPath isEqualToString:call.method]) {
        [self handlePlayWithPath:arguments result:result];
    } else if ([kTEPCallbackMethodPlayWithAsset isEqualToString:call.method]) {
        [self handlePlayWithAsset:arguments result:result];
    } else if ([kTEPCallbackMethodPause isEqualToString:call.method]) {
        [self handlePause:result];
    } else if ([kTEPCallbackMethodResume isEqualToString:call.method]) {
        [self handleResume:result];
    } else if ([kTEPCallbackMethodStop isEqualToString:call.method]) {
        [self handleStop:result];
    } else if ([kTEPCallbackMethodSetMute isEqualToString:call.method]) {
        [self handleSetMute:arguments result:result];
    } else if ([kTEPCallbackMethodSetLoop isEqualToString:call.method]) {
        [self handleSetLoop:arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


#pragma mark - Method Handlers

- (void)handleInitPlayerView:(NSDictionary *)arguments result:(FlutterResult)result {
    /// 加载需要缓存的数据
    [self loadCacheData:^() {
        if (self.autoStart) {
            if (self.playUrl != nil) {
                [self playUrl:self.playUrl];
            }else if (self.resourcePath != nil) {
                [self playPath:self.resourcePath isOtherCall:NO];
            }else if (self.assetName != nil) {
                [self playAsset:self.assetName];
            }
        }
    }];
}

- (void)handlePlayWithPath:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *path = arguments[kTEPMethodArgsKeyResourcePath];
    // 是否有设置isMute
    if (arguments[kTEPMethodArgsKeyMute] != nil) {
        BOOL isMute = [arguments[kTEPMethodArgsKeyMute] boolValue];
        [self.alphaAnimView setMute:isMute];
    }
    if (path != nil && path.length > 0) {
        [self playPath:path isOtherCall:NO];
        result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
    }else {
        result(@{
            kTEPMethodArgsKeyStatus: kTEPMethodArgsValueError,
            kTEPMethodArgsKeyMessage: @"Path is required"
        });
    }
}

- (void)handlePlayWithUrl:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *url = arguments[kTEPMethodArgsKeyPlayUrl];
    // 是否有设置isMute
    if (arguments[kTEPMethodArgsKeyMute] != nil) {
        BOOL isMute = [arguments[kTEPMethodArgsKeyMute] boolValue];
        [self.alphaAnimView setMute:isMute];
    }
    if (url.length > 0) {
        [self playUrl:url];
        result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
    } else {
        result(@{
            kTEPMethodArgsKeyStatus: kTEPMethodArgsValueError,
            kTEPMethodArgsKeyMessage: @"URL is required"
        });
    }
}

- (void)handlePlayWithAsset:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *asset = arguments[kTEPMethodArgsKeyAssetName];
    // 是否有设置isMute
    if (arguments[kTEPMethodArgsKeyMute] != nil) {
        BOOL isMute = [arguments[kTEPMethodArgsKeyMute] boolValue];
        [self.alphaAnimView setMute:isMute];
    }
    if (asset.length > 0) {
        [self playAsset:asset];
        result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
    } else {
        result(@{
            kTEPMethodArgsKeyStatus: kTEPMethodArgsValueError,
            kTEPMethodArgsKeyMessage: @"Asset is required"
        });
    }
}

- (void)handlePause:(FlutterResult)result {
    [self.alphaAnimView pause];
    result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
}

- (void)handleResume:(FlutterResult)result {
    [self.alphaAnimView resume];
    result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
}

- (void)handleStop:(FlutterResult)result {
    [self.alphaAnimView stopPlay];
    result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
}

- (void)handleSetMute:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *muteValue = arguments[kTEPMethodArgsKeyMute];
    if (muteValue != nil) {
        [self.alphaAnimView setMute:muteValue.boolValue];
        result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
    } else {
        result(@{
            kTEPMethodArgsKeyStatus: kTEPMethodArgsValueError,
            kTEPMethodArgsKeyMessage: @"Mute value is required"
        });
    }
}

- (void)handleSetLoop:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *loopValue = arguments[kTEPMethodArgsKeyLoop];
    if (loopValue != nil) {
        [self.alphaAnimView setLoop:loopValue.boolValue];
        result(@{kTEPMethodArgsKeyStatus: kTEPMethodArgsValueSuccess});
    } else {
        result(@{
            kTEPMethodArgsKeyStatus: kTEPMethodArgsValueError,
            kTEPMethodArgsKeyMessage: @"Loop value is required"
        });
    }
}


#pragma mark - Player View delegate

/**
 * 播放器事件通知
 * @param player    播放器对象
 * @param EvtID     Event ID
 * @param param      附加参数
 *
 * * Player event notification
 * -param player        effect player
 * -param EvtID    Event ID
 * -param param     additional parameters
 */
- (void)onPlayEvent:(ITCEffectPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param {
    
    if (EvtID == 200001) {
        TCEPAnimConfig *config = param[@"alphaAnimConfig"];
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc]init];
        configDict[@"version"] = @(config.version);
        
        configDict[@"framesCount"] = @(config.framesCount);
        
        configDict[@"size"] = @{
            @"width":@(config.size.width),
            @"height":@(config.size.height)
        };
        
        configDict[@"videoSize"] = @{
            @"width":@(config.videoSize.width),
            @"height":@(config.videoSize.height)
        };
        
        configDict[@"targetOrientaion"] = @(config.targetOrientaion);
        
        configDict[@"fps"] = @(config.fps);
        
        configDict[@"alphaAreaRect"] = @{
            @"x":@(config.alphaAreaRect.origin.x),
            @"y":@(config.alphaAreaRect.origin.y),
            @"width":@(config.alphaAreaRect.size.width),
            @"height":@(config.alphaAreaRect.size.height)
        };
        
        configDict[@"rgbAreaRect"] = @{
            @"x":@(config.rgbAreaRect.origin.x),
            @"y":@(config.rgbAreaRect.origin.y),
            @"width":@(config.rgbAreaRect.size.width),
            @"height":@(config.rgbAreaRect.size.height)
        };
        
        NSMutableDictionary *tmpArgs = [[NSMutableDictionary alloc]init];
        tmpArgs[kTEPMethodArgsKeyViewId] = self.viewId;
        tmpArgs[kTEPMethodArgsKeyEventId] = @(EvtID);
        tmpArgs[kTEPMethodArgsKeyParam] = @{@"alphaAnimConfig":[[NSDictionary alloc] initWithDictionary:configDict]};

        NSDictionary *args = [NSDictionary dictionaryWithDictionary:tmpArgs];
        
        [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewEvent
                               arguments:args];
    }else {
        NSMutableDictionary *tmpArgs = [[NSMutableDictionary alloc]init];
        tmpArgs[kTEPMethodArgsKeyViewId] = self.viewId;
        tmpArgs[kTEPMethodArgsKeyEventId] = @(EvtID);
        if (param != nil) {
            tmpArgs[kTEPMethodArgsKeyParam] = param;
        }

        NSDictionary *args = [NSDictionary dictionaryWithDictionary:tmpArgs];
        
        [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewEvent
                               arguments:args];
    }
    
    
   
}

/**
 * 替换融合动画资源配置中的文本占位符，如果要支持配置文件的对齐方式、颜色等属性，请使用 loadTextForPlayer。
 * @param player     特效播放器对象
 * @param tag   标签
 *
 * Note: This interface has been deprecated. Please use loadTextForPlayer interface.
 * Replace resource placeholders in Fusion Animation resource configuration
 * -param player    effect player
 * -param tag   tag
 */
- (NSString *)textContentForPlayer:(ITCEffectPlayer *)player
                           withTag:(NSString *)tag {
    return self.textContentCache[tag];
}


/**
 * 替换融合动画资源配置中的文本占位符， 支持配置文件的对齐方式、颜色等属性。
 * @param player     特效播放器对象
 * @param tag   标签
 *
 * Replace the text placeholder in the Fusion Animation resource configuration, and support the configuration file's alignment, color and other properties.
 * -param player    effect player
 * -param tag   tag
 */
- (TCEffectText *)loadTextForPlayer:(ITCEffectPlayer *)player
                            withTag:(NSString *)tag {

    return self.loadTextCache[tag];
}


/**
 * 传入融合动画资源中的图片信息
 * @param player    特效播放器对象
 * @param context   resource资源信息 (如:  .mp4文件 ) 或 透传的index信息 (如:  .tepg文件 )，
 *                具体参数见 TCEPConstant.h
 * @param completionBlock    回调
 *
 * * Pass in the image information in the fusion animation resource
 * -param player    effect player
 * -param context   resource information ( for .mp4 file ) or index information (for .tepg file)
 * -param completionBlock   callback
 */
- (void)loadImageForPlayer:(ITCEffectPlayer *)player
                   context:(NSDictionary *)context
                completion:(void(^)(UIImage *image,
                                    NSError *error))completionBlock {
    // 使用url作为tag
    NSString *tag = context[TCEPContextSourceTypeImageURL];
    NSDictionary *cacheItem = self.loadImageCache[tag];
    if (cacheItem != nil) {
        NSNumber *imageType = cacheItem[kTEPMethodArgsKeyImageType];
        if (imageType == nil) {
            completionBlock(nil, [NSError errorWithDomain:@"TCEffectPlayer" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Image type is required"}]);
            return;
        }
        NSString *imageValue = cacheItem[kTEPMethodArgsKeyImageValue];
        if (imageValue == nil) {
            completionBlock(nil, [NSError errorWithDomain:@"TCEffectPlayer" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Image value is required"}]);
            return;
        }

        if (imageType.intValue == TCEPImageTypeLocal) {
            // load with local path
            UIImage *image = [UIImage imageNamed:imageValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(image, nil);
            });
        }else if (imageType.intValue == TCEPImageTypeNetwork) {
            // load with network url
            NSURL *url = [NSURL URLWithString:imageValue];
            // download image
            NSURLSession *session = [NSURLSession sharedSession];   
            NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(image, nil);
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(nil, error);
                    });
                }
            }];
            [task resume];
        }else if (imageType.intValue == TCEPImageTypeAssets) {
            // load with assets
            
            
            NSString *resourcePath = [_registrar lookupKeyForAsset:imageValue];
            resourcePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:nil];
            if (resourcePath == nil) {
                completionBlock(nil, [NSError errorWithDomain:@"TCEffectPlayer" code:-4 userInfo:@{NSLocalizedDescriptionKey: @"Image not found"}]);
                return;
            }
            UIImage *image = [UIImage imageWithContentsOfFile:resourcePath];
            
            if (image == nil) {
                completionBlock(nil, [NSError errorWithDomain:@"TCEffectPlayer" code:-5 userInfo:@{NSLocalizedDescriptionKey: @"Image not found"}]);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(image, nil);
            });
            
        }
        
    }else {
        completionBlock(nil, [NSError errorWithDomain:@"TCEffectPlayer" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Image not found"}]);
    }
    
}

/**
 * 融合动画资源点击事件回调
 * @param player    特效播放器对象
 * @param tag   标签
 *
 * Fusion animation resource click event callback
 * -param player    effect player
 * -param tag   resource tag
 */
- (void)tcePlayerTagTouchBegan:(ITCEffectPlayer *)player tag:(NSString *)tag {
    [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewClickEvent
                           arguments:@{kTEPMethodArgsKeyViewId: self.viewId}];
}

/**
 * 融合动画开始播放回调
 * @param player    特效播放器对象
 *
 * Effect player start to play callback
 * -param player    effect player
 */
- (void)tcePlayerStart:(ITCEffectPlayer *)player {
    [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewStart
                           arguments:@{kTEPMethodArgsKeyViewId: self.viewId}];
}

/**
 * 融合动画结束播放回调
 * @param player    特效播放器对象
 *
 * Effect player end to play callback
 * -param player   effect player
 */
- (void)tcePlayerEnd:(ITCEffectPlayer *)player {
    [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewEnd
                           arguments:@{kTEPMethodArgsKeyViewId: self.viewId}];
}


/**
 * 融合动画播放错误回调
 * @param player    特效播放器对象
 * @param error  错误对象信息
 *
 * Effect player play error callback
 * -param player   effect player
 * -param error  error info
 */
- (void)tcePlayerError:(ITCEffectPlayer *)player error:(NSError *)error {
    NSMutableDictionary *tmpArgs = [[NSMutableDictionary alloc]init];
    tmpArgs[kTEPMethodArgsKeyViewId] = self.viewId;
    
    if (error != nil) {
        NSMutableDictionary *editErrorDict = [[NSMutableDictionary alloc]init];
        editErrorDict[@"code"] = @(error.code);
        if (error.domain != nil) {
            editErrorDict[@"domain"] = error.domain;
        }
        if (error.userInfo != nil) {
            editErrorDict[@"userInfo"] = error.userInfo;
        }
        tmpArgs[kTEPMethodArgsKeyTCEPlayerError] = [[NSDictionary alloc]initWithDictionary:editErrorDict];
    }

    NSDictionary *args = [NSDictionary dictionaryWithDictionary:tmpArgs];
    [self.methodChannel invokeMethod:kTEPCallbackMethodTCEffectAnimViewError
                           arguments:args];
}

@end


