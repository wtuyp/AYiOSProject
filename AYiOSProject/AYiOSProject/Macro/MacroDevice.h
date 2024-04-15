//
//  MacroDevice.h
//
//  Created by MMM on 2021/6/25.
//

#ifndef MacroDevice_h
#define MacroDevice_h

// 屏幕宽、高
#define SCREEN_WIDTH            (UIScreen.mainScreen.bounds.size.width)
#define SCREEN_HEIGHT           (UIScreen.mainScreen.bounds.size.height)
#define SCREEN_SIZE             (UIScreen.mainScreen.bounds.size)

// 状态栏高
#define STATUS_BAR_HEIGHT       StatusBarHeight()

// 导航栏高
#define NAVI_BAR_HEIGHT         44

// 状态栏+导航栏高
#define STATUS_NAVI_BAR_HEIGHT  (STATUS_BAR_HEIGHT + NAVI_BAR_HEIGHT)

// TabBar高
#define TAB_BAR_HEIGHT          (ScreenSafeBottomHeight() + 49.0)

// 安全区底部高度
#define SAFE_BOTTOM             (ScreenSafeBottomHeight())

// 宽度比例
#define SCALE_WIDTH(width)      (ScreenWidthScale() * (width))

// 高度比例
#define SCALE_HEIGHT(height)    (ScreenHeightScale() * (height))

// 比例
#define SCALE(value)            ceil(ScreenWidthScale() * (value))

#define ONE_PIXEL               (1.0 / UIScreen.mainScreen.scale)

// 判断 iPad
#define IS_IPAD                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// 屏幕尺寸 数据来源 https://www.jianshu.com/p/b503f14b8574

// 判断iPhone X/XS/11Pro
#define IS_IPHONEX              ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhoneXR | 11
#define IS_IPHONEXR             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhoneXS Max | 11Pro Max
#define IS_IPHONEXS_MAX         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhone12 mini/13 mini
#define IS_IPHONE12_MINI        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhone12/12Pro/13/13Pro/14
#define IS_IPHONE12             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhone12 Pro Max/13 Pro Max/14 Plus
#define IS_IPHONE12_PROMAX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhone 14 Pro/15/15 Pro
#define IS_IPHONE14_PRO         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1179, 2556), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 判断iPhone 14 Pro Max/15 Plus/15 Pro Max
#define IS_IPHONE14_PROMAX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1290, 2796), [[UIScreen mainScreen] currentMode].size) && IS_IPHONE : NO)

// 流海系列
#define IS_IPHONEX_NOTCH        (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXS_MAX || IS_IPHONE12_MINI || IS_IPHONE12 || IS_IPHONE12_PROMAX || IS_IPHONE14_PRO || IS_IPHONE14_PROMAX)


static inline CGFloat StatusBarHeight(void) {
    static CGFloat height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        if (@available(iOS 13.0, *)) {
//            NSSet *set = [UIApplication sharedApplication].connectedScenes;
//            UIWindowScene *scene = [set anyObject];
//            UIStatusBarManager *manager = scene.statusBarManager;
//            height = manager.statusBarFrame.size.height;
//        } else {
            height = [UIApplication sharedApplication].statusBarFrame.size.height;
//        }
    });
    return height;
}

static inline CGFloat ScreenWidthScale(void) {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [[UIScreen mainScreen] bounds].size.width / (IS_IPHONE ? 375.f : 768.f);
    });
    return scale;
}

static inline CGFloat ScreenHeightScale(void) {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [[UIScreen mainScreen] bounds].size.height * 100.f / 667.f;
        scale = (NSInteger)scale / 100.f;
    });
    return scale;
}

static inline CGFloat ScreenSafeBottomHeight(void) {
    static CGFloat height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIEdgeInsets safeAreaInsets = window.safeAreaInsets;
        height = safeAreaInsets.bottom;
    });
    return height;
}

#endif /* MacroDevice_h */
