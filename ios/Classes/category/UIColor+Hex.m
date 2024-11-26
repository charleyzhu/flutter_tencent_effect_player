/**
 * @Author: Charley
 * @Description: UIColor hex string extension implementation
 */

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    // 删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 判断字符串是否符合要求
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    // 如果字符串长度不为6或8，返回清除色
    if ([cString length] != 6 && [cString length] != 8) {
        return [UIColor clearColor];
    }
    
    // 将字符串分成RGB三部分
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    // R
    NSString *rString = [cString substringWithRange:range];
    
    // G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    // B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // A
    CGFloat aValue = alpha;
    if ([cString length] == 8) {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        aValue = a / 255.0f;
    }
    
    // 取出RGB对应的值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:aValue];
}

@end 