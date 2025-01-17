//
//  MacroUtils.h
//
//  Created by MMM on 2021/6/27.
//

#ifndef MacroUtils_h
#define MacroUtils_h

// 颜色，十六进制字符串，如 COLOR_HEX(#ffffff)
#define COLOR_HEX(_hex_)        [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

// 字体
#define FONT(size)              [UIFont systemFontOfSize:SCALE(size)]
#define FONT_BOLD(size)         [UIFont boldSystemFontOfSize:SCALE(size)]
#define FONT_NUMBER(size)       [UIFont systemFontOfSize:SCALE(size)]

// 控制台打印控制 0-不打印，1打印
#if DEBUG
#define DEBUG_LOG               1
#else
#define DEBUG_LOG               0
#endif

// 控制台打印
#if DEBUG_LOG
    #define NSLog(...)          printf(">>>>>\n[%s] %s @%d \n%s\n", __TIME__, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
    #define printf(...)         printf(__VA_ARGS__)
#else
    #define NSLog(fmt, ...)
    #define printf(...)
#endif

// 获取 window
#define WINDOW                  (AppManager.shared.window)

// 生成 UIImage
#define IMAGE(name)             [UIImage imageNamed:name]//.scaleImage
#define IMAGE_COLOR(color)      [UIImage imageWithColor:(color)]

// String
#define STRING_FORMAT(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define STRING_SAFE(str)        (str && [str isKindOfClass:NSString.class] ? str : @"")
#define STRING_SAFE_DEFAULT(str, default)   (str && [str isKindOfClass:NSString.class] ? str : (default ?: @""))

// Date formatter
#define DATE_FORMATTER_YMDHMS   (@"yyyy-MM-dd HH:mm:ss")
#define DATE_FORMATTER_YMDHM    (@"yyyy-MM-dd HH:mm")
#define DATE_FORMATTER_YMD      (@"yyyy-MM-dd")

// 强弱化引用
#define WEAK_OBJ(object)        __weak typeof(object) weak##object = object;
#define STRONG_OBJ(object)      __strong typeof(object) object = weak##object;
#define WEAK_SELF               __weak typeof(self) weakSelf = self;
#define STRONG_SELF             __strong typeof(self) self = weakSelf;

#define APP_NAME                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

// 导航Push
#define NAVI_PUSH_CONTROLLER(fromC, toC)    [fromC.navigationController pushViewController:toC animated:YES];

#pragma mark - CG

CG_INLINE CGFloat removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

CG_INLINE CGFloat flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = removeFloatMin(floatValue);
    scale = scale ?: kScreenScale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

CG_INLINE CGFloat flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

CG_INLINE BOOL CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsRemoveFloatMin(UIEdgeInsets insets) {
    UIEdgeInsets result = UIEdgeInsetsMake(removeFloatMin(insets.top), removeFloatMin(insets.left), removeFloatMin(insets.bottom), removeFloatMin(insets.right));
    return result;
}

CG_INLINE CGRect CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = flat(x);
    return rect;
}

CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = flat(y);
    return rect;
}

CG_INLINE CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    if (width < 0) {
        return rect;
    }
    rect.size.width = flat(width);
    return rect;
}

CG_INLINE CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    if (height < 0) {
        return rect;
    }
    rect.size.height = flat(height);
    return rect;
}

CG_INLINE CGRect CGRectFlatted(CGRect rect) {
    return CGRectMake(flat(rect.origin.x), flat(rect.origin.y), flat(rect.size.width), flat(rect.size.height));
}

CG_INLINE CGRect CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

CG_INLINE CGFloat CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flat((parent - child) / 2.0);
}

CG_INLINE CGFloat UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

CG_INLINE CGFloat UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

#pragma mark - ENUM

/// 渐变方向
typedef NS_ENUM(NSUInteger,  GradientDirection) {
    GradientDirectionLeftToRight = 0,       // 从左到右
    GradientDirectionRightToLeft,           // 从右到左
    GradientDirectionTopToBottom,           // 从上到下
    GradientDirectionBottomToTop,           // 从下到上
    GradientDirectionTopLeftToBottomRight,  // 从左上到右下
    GradientDirectionBottomLeftToTopRight,  // 从左下到右上
    GradientDirectionTopRightToBottomLeft,  // 从右上到左下
    GradientDirectionBottomRightToTopLeft,  // 从右下到左上
};

#endif /* MacroUtils_h */
