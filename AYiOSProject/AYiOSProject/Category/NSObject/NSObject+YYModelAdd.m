//
//  NSObject+YYModelAdd.m
//
//  Created by alpha yu on 2022/11/18.
//

#import "NSObject+YYModelAdd.h"

@implementation NSObject (YYModelAdd)

+ (NSArray *)modelArrayWithJson:(id)json {
    return [NSArray yy_modelArrayWithClass:self.class json:json];
}

@end
