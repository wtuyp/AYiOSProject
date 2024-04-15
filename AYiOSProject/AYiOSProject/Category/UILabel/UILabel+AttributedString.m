//
//  UILabel+AttributedString.m
//
//  Created by linxj on 2022/11/10.
//

#import "UILabel+AttributedString.h"

@implementation UILabel (AttributedString)

- (void)setFont:(UIFont *)font substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSFontAttributeName value:font range:range];
    }
}

- (void)setColor:(UIColor *)color substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (void)setKern:(CGFloat)value {
    [self setKern:value substring:self.text];
}

- (void)setKern:(CGFloat)value substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSKernAttributeName value:@(value) range:range];
    }
}

- (void)addLineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpacing;
    [self setAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:NSMakeRange(0, self.text.length)];
}

- (void)addStrikethrough {
    [self setStrikethroughStyle:NSUnderlineStyleSingle];
}

- (void)removeStrikethrough {
    [self setStrikethroughStyle:NSUnderlineStyleNone];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)style {
    [self setStrikethroughStyle:style substring:self.text];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)style substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSStrikethroughStyleAttributeName
                     value:@(style)
                     range:range];
    }
}

- (void)setStrikethroughColor:(UIColor *)color {
    [self setStrikethroughColor:color substring:self.text];
}

- (void)setStrikethroughColor:(UIColor *)color substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSStrikethroughColorAttributeName
                     value:color
                     range:range];
    }
}

- (void)addUnderline {
    [self setUnderlineStyle:NSUnderlineStyleSingle];
}

- (void)removeUnderline {
    [self setUnderlineStyle:NSUnderlineStyleNone];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)style {
    [self setUnderlineStyle:style substring:self.text];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)style substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSUnderlineStyleAttributeName
                     value:@(style)
                     range:range];
    }
}

- (void)setUnderlineColor:(UIColor *)color {
    [self setUnderlineColor:color substring:self.text];
}

- (void)setUnderlineColor:(UIColor *)color substring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location != NSNotFound) {
        [self setAttribute:NSUnderlineColorAttributeName
                     value:color
                     range:range];
    }
}

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (value && ![NSNull isEqual:value]) {
        [attributedString addAttribute:name value:value range:range];
    } else {
        [attributedString removeAttribute:name range:range];
    }
    self.attributedText = attributedString;
}

- (void)removeAttributesInRange:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString setAttributes:nil range:range];
    self.attributedText = attributedString;
}

@end
