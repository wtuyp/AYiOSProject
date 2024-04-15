//   
//  AppIndexDataModel.m
//   
//  Created by alpha yu on 2024/3/8 
//   
   

#import "AppIndexDataModel.h"

@interface AppIndexDataModel ()

@end

@implementation AppIndexDataModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"index" : @[@"index", @"letter"],
        @"list" : @[@"list", @"data"],
    };
}

@end
