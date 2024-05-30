//
//  TitleImageButton.m
//
//  Created by tens on 2022/11/15.
//

#import "TitleImageButton.h"

@interface TitleImageButton ()

@property (nonatomic, assign) TitleImageButtonImagePosition imagePosition;
@property (nonatomic, assign) CGFloat gapBetweenImageAndTitle;

@property (nonatomic, strong) CALayer *highlightedBackgroundLayer;
@property (nonatomic, strong) UIColor *originBorderColor;

@end

@implementation TitleImageButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initParams];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initParams];
    }
    return self;
}


- (void)initParams {
    self.contentEdgeInsets = UIEdgeInsetsMake(CGFLOAT_MIN, 0, CGFLOAT_MIN, 0);

    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    self.adjustsButtonWhenHighlighted = YES;
    self.adjustsButtonWhenDisabled = YES;
    
    self.imagePosition = TitleImageButtonImagePositionLeft;
}

- (UIImageView *)p_imageView {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:NSSelectorFromString(@"_imageView")];
#pragma clang diagnostic pop
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    if (CGSizeEqualToSize(self.bounds.size, size) || CGSizeIsEmpty(size)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || self.currentAttributedTitle;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat gapBetweenImageAndTitle = flat(isImageViewShowing && isTitleLabelShowing ? self.gapBetweenImageAndTitle : 0);// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsRemoveFloatMin(self.contentEdgeInsets);
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(contentEdgeInsets));
        
    switch (self.imagePosition) {
        case TitleImageButtonImagePositionTop:
        case TitleImageButtonImagePositionBottom: {
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            if (isImageViewShowing) {
                CGFloat imageLimitWidth = contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)] : self.currentImage.size;
                imageSize.width = fmin(imageSize.width, imageLimitWidth);
                imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentLimitSize.height - imageTotalSize.height - gapBetweenImageAndTitle - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = MIN(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            }
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(contentEdgeInsets);
            resultSize.width += MAX(imageTotalSize.width, titleTotalSize.width);
            resultSize.height = UIEdgeInsetsGetVerticalValue(contentEdgeInsets) + imageTotalSize.height + gapBetweenImageAndTitle + titleTotalSize.height;
        }
            break;
            
        case TitleImageButtonImagePositionLeft:
        case TitleImageButtonImagePositionRight: {
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 QMUIButtonImagePositionLeft 并且titleLabel 多行的情况下，QMUIButton 计算的结果与系统不一致
            
            if (isImageViewShowing) {
                CGFloat imageLimitHeight = contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)] : self.currentImage.size;
                imageSize.height = MIN(imageSize.height, imageLimitHeight);
                imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageTotalSize.width - gapBetweenImageAndTitle, contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fmin(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            }
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(contentEdgeInsets) + imageTotalSize.width + gapBetweenImageAndTitle + titleTotalSize.width;
            resultSize.height = UIEdgeInsetsGetVerticalValue(contentEdgeInsets);
            resultSize.height += MAX(imageTotalSize.height, titleTotalSize.height);
        }
            break;
    }
    return resultSize;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || !!self.currentAttributedTitle;
    CGSize imageLimitSize = CGSizeZero;
    CGSize titleLimitSize = CGSizeZero;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat gapBetweenImageAndTitle = flat(isImageViewShowing && isTitleLabelShowing ? self.gapBetweenImageAndTitle : 0);// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    CGRect imageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsRemoveFloatMin(self.contentEdgeInsets);
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(contentEdgeInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(contentEdgeInsets));
    
    // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
    if (isImageViewShowing) {
        imageLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
        CGSize imageSize = self.p_imageView.image ? [self.p_imageView sizeThatFits:imageLimitSize] : self.currentImage.size;
        imageSize.width = MIN(imageLimitSize.width, imageSize.width);
        imageSize.height = MIN(imageLimitSize.height, imageSize.height);
        imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
    }
    
    // UIButton 如果本身大小为 (0,0)，此时设置一个 imageEdgeInsets 会让 imageView 的 bounds 错误，导致后续 imageView 的 subviews 布局时会产生偏移，因此这里做一次保护
    void (^makesureBoundsPositive)(UIView *) = ^void(UIView *view) {
        CGRect bounds = view.bounds;
        if (CGRectGetMinX(bounds) < 0 || CGRectGetMinY(bounds) < 0) {
            bounds = CGRectMakeWithSize(bounds.size);
            view.bounds = bounds;
        }
    };
    if (isImageViewShowing) {
        makesureBoundsPositive(self.p_imageView);
    }
    if (isTitleLabelShowing) {
        makesureBoundsPositive(self.titleLabel);
    }
    
    if (self.imagePosition == TitleImageButtonImagePositionTop || self.imagePosition == TitleImageButtonImagePositionBottom) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentSize.height - imageTotalSize.height - gapBetweenImageAndTitle - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = MIN(titleLimitSize.width, titleSize.width);
            titleSize.height = MIN(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        }
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left + CGFloatGetCenter(imageLimitSize.width, CGRectGetWidth(imageFrame))) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left + CGFloatGetCenter(titleLimitSize.width, CGRectGetWidth(titleFrame))) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                    imageFrame = CGRectSetWidth(imageFrame, imageLimitSize.width);
                }
                if (isTitleLabelShowing) {
                    titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                    titleFrame = CGRectSetWidth(titleFrame, titleLimitSize.width);
                }
                break;
            default:
                break;
        }
        
        if (self.imagePosition == TitleImageButtonImagePositionTop) {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + gapBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + gapBetweenImageAndTitle + titleTotalSize.height;
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, minY + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, minY + imageTotalSize.height + gapBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - titleTotalSize.height - gapBetweenImageAndTitle - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + gapBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame)) : titleFrame;
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                    }
                }
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + titleTotalSize.height + gapBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + titleTotalSize.height + gapBetweenImageAndTitle;
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, minY + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, minY + titleTotalSize.height + gapBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - gapBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - gapBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                    }
                }
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self.p_imageView.frame = CGRectFlatted(imageFrame);
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = CGRectFlatted(titleFrame);
        }
        
    } else if (self.imagePosition == TitleImageButtonImagePositionLeft || self.imagePosition == TitleImageButtonImagePositionRight) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageTotalSize.width - gapBetweenImageAndTitle, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = MIN(titleLimitSize.width, titleSize.width);
            titleSize.height = MIN(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMakeWithSize(titleSize);
            titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                
                break;
            case UIControlContentVerticalAlignmentCenter:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(imageFrame)) + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(titleFrame)) + self.titleEdgeInsets.top) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentBottom:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                    imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                }
                if (isTitleLabelShowing) {
                    titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                }
                break;
        }
        
        if (self.imagePosition == TitleImageButtonImagePositionLeft) {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft:
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + gapBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + gapBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, minX + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, minX + imageTotalSize.width + gapBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight: {
                    if (imageTotalSize.width + gapBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + gapBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠右布局即可
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - titleTotalSize.width - gapBetweenImageAndTitle - imageTotalSize.width + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + gapBetweenImageAndTitle + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = CGRectSetWidth(imageFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets));
                    }
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft: {
                    if (imageTotalSize.width + gapBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - gapBetweenImageAndTitle - titleTotalSize.width + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠左布局即可
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + titleTotalSize.width + gapBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + gapBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, minX + self.titleEdgeInsets.left) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, minX + titleTotalSize.width + gapBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - gapBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 图片按自身大小显示，剩余空间由标题占满
                        imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - gapBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = CGRectSetWidth(imageFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets));
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self.p_imageView.frame = CGRectFlatted(imageFrame);
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = CGRectFlatted(titleFrame);
        }
    }
}

- (void)setGapBetweenImageAndTitle:(CGFloat)gapBetweenImageAndTitle {
    _gapBetweenImageAndTitle = gapBetweenImageAndTitle;
    
    [self setNeedsLayout];
}

- (void)setImagePosition:(TitleImageButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self setNeedsLayout];
}

- (void)setImagePosition:(TitleImageButtonImagePosition)imagePosition gapToTitle:(CGFloat)gap {
    _imagePosition = imagePosition;
    _gapBetweenImageAndTitle = gap;
    [self setNeedsLayout];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if (_highlightedBackgroundColor) {
        // 只要开启了highlightedBackgroundColor，就默认不需要alpha的高亮
        self.adjustsButtonWhenHighlighted = NO;
    }
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor {
    _highlightedBorderColor = highlightedBorderColor;
    if (_highlightedBorderColor) {
        // 只要开启了highlightedBorderColor，就默认不需要alpha的高亮
        self.adjustsButtonWhenHighlighted = NO;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted && !self.originBorderColor) {
        // 手指按在按钮上会不断触发setHighlighted:，所以这里做了保护，设置过一次就不用再设置了
        self.originBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
    }
    
    // 渲染背景色
    if (self.highlightedBackgroundColor || self.highlightedBorderColor) {
        [self adjustsButtonHighlighted];
    }
    // 如果此时是disabled，则disabled的样式优先
    if (!self.enabled) {
        return;
    }
    // 自定义highlighted样式
    if (self.adjustsButtonWhenHighlighted) {
        if (highlighted) {
            self.alpha = 0.7;
        } else {
            self.alpha = 1;
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled && self.adjustsButtonWhenDisabled) {
        self.alpha = 0.5;
    } else {
        self.alpha = 1;
    }
}

- (void)adjustsButtonHighlighted {
    if (self.highlightedBackgroundColor) {
        if (!self.highlightedBackgroundLayer) {
            self.highlightedBackgroundLayer = [CALayer layer];
            [self.layer insertSublayer:self.highlightedBackgroundLayer atIndex:0];
        }
        self.highlightedBackgroundLayer.frame = self.bounds;
        self.highlightedBackgroundLayer.cornerRadius = self.layer.cornerRadius;
        self.highlightedBackgroundLayer.maskedCorners = self.layer.maskedCorners;
        self.highlightedBackgroundLayer.backgroundColor = self.highlighted ? self.highlightedBackgroundColor.CGColor : UIColor.clearColor.CGColor;
    }
    
    if (self.highlightedBorderColor) {
        self.layer.borderColor = self.highlighted ? self.highlightedBorderColor.CGColor : self.originBorderColor.CGColor;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self imageView];
}

+ (instancetype)buttonWithTitle:(NSString *)title
                          color:(UIColor *)color
                           font:(UIFont *)font
                          image:(UIImage *)image
                  selectedImage:(UIImage *)selectedImage
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap {
    TitleImageButton *btn = [TitleImageButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    btn.titleLabel.font = font;
    [btn setImagePosition:imagePosition gapToTitle:gap];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title
                  selectedTitle:(NSString *)selectedTitle
                          color:(UIColor *)color
                           font:(UIFont *)font
                          image:(UIImage *)image
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap {
    TitleImageButton *btn = [TitleImageButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setImagePosition:imagePosition gapToTitle:gap];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title
                          color:(UIColor *)color
                  selectedColor:(UIColor *)selectedColor
                           font:(UIFont *)font
                          image:(UIImage *)image
                  selectedImage:(UIImage *)selectedImage
                  imagePosition:(TitleImageButtonImagePosition)imagePosition
                            gap:(CGFloat)gap {
    TitleImageButton *btn = [TitleImageButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    btn.titleLabel.font = font;
    [btn setImagePosition:imagePosition gapToTitle:gap];
    return btn;
}

@end
