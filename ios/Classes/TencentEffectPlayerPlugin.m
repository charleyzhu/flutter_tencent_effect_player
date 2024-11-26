#import "TencentEffectPlayerPlugin.h"
#import <TCMediaX/TCMediaX.h>
#import "TEPNativeView.h"
#import "constant.h"


@interface TencentEffectPlayerPlugin()
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, assign) int mRetryCount;
@property (nonatomic, copy, readonly) NSString *licenceUrlPath;
@property (nonatomic, copy, readonly) NSString *licenseKey;
@end

@implementation TencentEffectPlayerPlugin
static TencentEffectPlayerPlugin *_instance = nil;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"tencent_effect_player"
              binaryMessenger:[registrar messenger]];
    
    TencentEffectPlayerPlugin* instance = [[TencentEffectPlayerPlugin alloc] 
        initWithRegistrar:registrar
                Channel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FLNativeViewFactory* factory = [[FLNativeViewFactory alloc] 
                                    initWithRegistrar:registrar];
    [registrar registerViewFactory:factory withId:TENCENT_EFFECT_PLAYER_VIEW_TYPE];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar 
                        Channel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _registrar = registrar;
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([kMethodGetSDKVersion isEqualToString:call.method]) {
        
        result([@"SDK Version " stringByAppendingString:[[TCMediaXBase getInstance] getSdkVersion]]);
    } else if ([kMethodInitSDK isEqualToString:call.method]) {
        NSString *licenceUrl = call.arguments[kMethodArgsKeyLicenceUrl];
        NSString *licenceKey = call.arguments[kMethodArgsKeyLicenceKey];
        BOOL isLogEnable = [call.arguments[kMethodArgsKeyIsLogEnable] boolValue];
        // 初始化SDK
        [self setLicenceURL:licenceUrl 
                licenceKey:licenceKey
                isLogEnable:isLogEnable
                   result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)setLicenceURL:(NSString *)licenceUrl 
           licenceKey:(NSString *)licenceKey
          isLogEnable:(BOOL)isLogEnable
              result:(FlutterResult)result {
    if (licenceUrl != nil &&  licenceUrl.length > 0) {
        _licenceUrlPath =  [[NSURL URLWithString:licenceUrl] path];
    }
    _licenseKey = licenceKey;
    [[TCMediaXBase getInstance] setLogEnable:isLogEnable];
    [[TCMediaXBase getInstance] setDelegate:self];
    [[TCMediaXBase getInstance] setLicenceURL:licenceUrl key:licenceKey];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"status"] = @"success";
    result(dict);
}

#pragma mark - Helper Methods

/**
 * License 可以使用的备用域名， 在被 License 域名被劫持或域名不能访问后，用下面的域名替换后进行重试
 * 域名 1： plugin.vodglcdn.com
 * 域名 2： plugin.vod-common.com
 * 重试时使用不同域名的 License Url
 * 使用时请把 $your_license_url_suffix 替换为您的 LicenseUrl 后缀，
 * 例如：如果您的 License Url 为 https://trtc-plugin.qcloud.com/plugin/v1/1301671788/license.json，
 * 则把 $your_license_url_suffix 替换为 plugin/v1/1301671788/license.json
// */
- (NSArray<NSString *> *)getBackupLicenseUrl {
    if (self.licenceUrlPath == nil) {
        return @[];
    }
    return @[
        [NSString stringWithFormat:@"https://plugin.vodglcdn.com%@",self.licenceUrlPath],
        [NSString stringWithFormat:@"https://plugin.vod-common.com%@",self.licenceUrlPath],
    ];
}

#pragma mark - TCMediaXBaseDelegate

- (void)onLicenseCheckCallback:(int)errcode withParam:(NSDictionary *)param {
//    NSLog(@"onLicenseCheckCallback:%d", errcode);
    if (errcode == TMXLicenseCheckOk) {
        [self.channel invokeMethod:kCallbackMethodLicenseCheckSuccess arguments:nil];
    }else {
        NSDictionary *args = @{
            kMethodArgsKeyErrCode: @(errcode),
            kMethodArgsKeyParam: param
        };

        [self.channel invokeMethod:kCallbackMethodLicenseCheckError arguments:args];
        
        if (errcode == TMXLicenseCheckDownloadError) {
            NSArray<NSString *> *bakeUpLicenseUrl = [self getBackupLicenseUrl];
            if (self.mRetryCount < bakeUpLicenseUrl.count) {
                // License校验，用替换域名后的 License Url 进行重试
                // 此时业务可以把 LicenseUrl、错误码、网络状态进行上报，然后反馈给腾讯云播放器客服
                NSString *licenseUrl = bakeUpLicenseUrl[self.mRetryCount % bakeUpLicenseUrl.count];
                NSLog(@"retry licenseUrl: %@", licenseUrl);
                [[TCMediaXBase getInstance] setLicenceURL:licenseUrl key:self.licenseKey];
                self.mRetryCount++;
            } else {
                // 超过重试次数，可能是网络不可用，可以发消息给 app 进行相关提示，找另外时机重新调用 TCMediaXBase#setLicense
                self.mRetryCount = 0;
            }
        }
    }
    
}

@end
