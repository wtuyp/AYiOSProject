//   
//  AppAlert.h
//   
//  Created by alpha yu on 2023/2/16 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppAlert : NSObject

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelTitle:(NSString * _Nullable)cancelTitle
               actionTitle:(NSString * _Nullable)actionTitle
               actionBlock:(void (^ _Nullable)(void))actionBlock;

+ (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               cancelTitle:(NSString * _Nullable)cancelTitle
               actionTitle:(NSString * _Nullable)actionTitle
               cancelBlock:(void (^ _Nullable)(void))cancelBlock
               actionBlock:(void (^ _Nullable)(void))actionBlock;

+ (void)dimissAlert;

@end

NS_ASSUME_NONNULL_END
