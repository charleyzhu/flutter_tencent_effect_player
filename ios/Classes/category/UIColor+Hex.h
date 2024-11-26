/**
 * @Author: Charley
 * @Description: UIColor hex string extension
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

/**
 * 通过十六进制字符串创建颜色
 * @param hexString 十六进制颜色字符串，支持 #RGB、#RGBA、#RRGGBB、#RRGGBBAA 格式
 * @return UIColor 实例
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 * 通过十六进制字符串创建颜色
 * @param hexString 十六进制颜色字符串，支持 #RGB、#RGBA、#RRGGBB、#RRGGBBAA 格式
 * @param alpha 透明度值，范围 0-1
 * @return UIColor 实例
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END 