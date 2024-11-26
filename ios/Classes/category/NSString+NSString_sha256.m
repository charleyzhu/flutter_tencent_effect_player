//
//  NSString+NSString_md5.m
//  hi_party_pag_plugin
//
//  Created by Charley on 11/11/2024.
//

#import "NSString+NSString_sha256.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString_md5)
- (NSString *)sha256 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
@end
