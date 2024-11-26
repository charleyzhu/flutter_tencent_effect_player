//  Copyright © 2023年 Tencent. All rights reserved.

#ifndef TCMediaXManagerDef_h
#define TCMediaXManagerDef_h
#import <Foundation/Foundation.h>

/**
 *  MediaX Licence检查错误码
 */
typedef NS_ENUM(NSInteger, TCMediaXLicenceCheckErrorCode) {
    
    TMXLicenseCheckOk = 0,                  // 成功
    TMXLicenseCheckNotSet = -1,             // license没有被正确设置完毕。检查是否已经setLicense并接收到成功回调
    TMXLicenseCheckJsonError = -2,          // license字段里的json字段错误,解析错误
    TMXLicenseCheckDownloadError = -3,      // 下载环节失败，请检查网络设置
    TMXLicenseCheckLocalLicenseEmpty = -4,  // 从本地读取的授权信息为空
    TMXLicenseCheckPackageNotMatch = -5,    // 包名不一致
    TMXLicenseCheckExpired = -6,            // license过期
    TMXLicenseCheckSignatureError = -7,     // 签名校验失败
    TMXLicenseCheckFeatureNotSupported = -8,   // feature不支持
    TMXLicenseCheckDecodeError = -9,        // 解密失败
};

#endif /* TCMediaXManagerDef_h */
