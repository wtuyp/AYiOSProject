//
//  NSObject+YYModelAdd.h
//
//  Created by alpha yu on 2022/11/18.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

/* NSCoding */
#define YY_CODING_IMP \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

/* NSCopying */
#define YY_COPYING_IMP \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YYModelAdd)

+ (NSArray *)modelArrayWithJson:(id)json;

@end

NS_ASSUME_NONNULL_END
