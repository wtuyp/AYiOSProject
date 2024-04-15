//   
//  AccountInfoController.m
//   
//  Created by alpha yu on 2024/2/2 
//   
   

#import "AccountInfoController.h"
#import <TZImagePickerController/TZImagePickerController.h>

#import "StringsPickerPopupView.h"
#import "DatePickerPopupView.h"

@interface AccountInfoController ()

@property (nonatomic, strong) UIImageView *avatarView;          ///< 头像
@property (nonatomic, strong) UILabel *nameLabel;               ///< 姓名
@property (nonatomic, strong) UILabel *genderLabel;             ///< 性别
@property (nonatomic, strong) UILabel *birthdayLabel;           ///< 生日
@property (nonatomic, strong) UILabel *phoneLabel;              ///< 手机

@end

@implementation AccountInfoController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";

    [self setupData];
    [self setupNavigationBarItems];
    [self setupSubviews];
    
    AccountInfoModel *account = AccountManager.shared.account;
    if (account) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:IMAGE(@"mine_avatar_55")];
        self.nameLabel.text = account.name;
        self.genderLabel.text = account.gender;
        self.birthdayLabel.text = account.birthday;
        self.phoneLabel.text = account.phoneNumber;
    }
}

#pragma mark - override


#pragma mark - data

- (void)setupData {

}

#pragma mark - view

- (void)setupNavigationBarItems {
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:<#view#>];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupSubviews {
    self.view.backgroundColor = COLOR_HEX(#F7F7F7);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, SAFE_BOTTOM, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(0);
    }];

    // 内容
    UIView *itemViewContainerView = [[UIView alloc] init];
    itemViewContainerView.backgroundColor = UIColor.whiteColor;
    [itemViewContainerView setCornerRadius:13];
    
    UIView *itemView0 = [self createItemViewWithTitle:@"头像" valueView:self.avatarView tapAction:@selector(showAvatarPicker) showArrow:NO showBottomLine:YES];
    UIView *itemView1 = [self createItemViewWithTitle:@"姓名" valueView:self.nameLabel tapAction:nil showArrow:NO showBottomLine:YES];
    UIView *itemView2 = [self createItemViewWithTitle:@"生日" valueView:self.birthdayLabel tapAction:@selector(showBirthdayPicker) showArrow:YES showBottomLine:YES];
    UIView *itemView3 = [self createItemViewWithTitle:@"性别" valueView:self.genderLabel tapAction:@selector(showGenerPicker) showArrow:YES showBottomLine:YES];
    UIView *itemView4 = [self createItemViewWithTitle:@"手机" valueView:self.phoneLabel tapAction:nil showArrow:NO showBottomLine:NO];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setNormalWithTitle:@"退出登录" color:COLOR_HEX(#FFFFFF) font:FONT(17)];
    logoutBtn.backgroundColor = COLOR_HEX(#8A7DF4);
    [logoutBtn setCornerRadius:3];
    [logoutBtn addTarget:self action:@selector(logoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [scrollView.vContainerView addSubview:itemViewContainerView];
    [scrollView.vContainerView addSubview:logoutBtn];
    
    [itemViewContainerView addSubview:itemView0];
    [itemViewContainerView addSubview:itemView1];
    [itemViewContainerView addSubview:itemView2];
    [itemViewContainerView addSubview:itemView3];
    [itemViewContainerView addSubview:itemView4];

    [itemViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(SCALE(18));
        make.top.mas_equalTo(SCALE(35));
    }];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCALE(325), SCALE(42)));
        make.centerX.mas_equalTo(0);
        make.top.equalTo(itemViewContainerView.mas_bottom).offset(SCALE(36));
        make.bottom.mas_equalTo(0);
    }];


    [itemViewContainerView verticalLayoutSubviewsWithItemHeight:SCALE(46) itemSpacing:0];
}

#pragma mark - getter

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:IMAGE(@"mine_avatar_55")];
        [_avatarView setCornerRadius:SCALE(16) clip:YES];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16)];
    }
    return _nameLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16)];
    }
    return _genderLabel;
}

- (UILabel *)birthdayLabel {
    if (!_birthdayLabel) {
        _birthdayLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16)];
    }
    return _birthdayLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithColor:COLOR_HEX(#000000) font:FONT_BOLD(16)];
    }
    return _phoneLabel;
}

- (UIView *)createItemViewWithTitle:(NSString *)title
                          valueView:(UIView * _Nullable)valueView
                          tapAction:(SEL _Nullable)tapAction
                          showArrow:(BOOL)showArrow
                     showBottomLine:(BOOL)showBottomLine {
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [UILabel labelWithColor:COLOR_HEX(#646464) font:FONT_BOLD(16) text:title];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_arrow_right_gray_7_11")];
    UIView *lineView = [UIView viewWithColor:COLOR_HEX(#D2D2D2)];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (tapAction) {
        [actionBtn addTarget:self action:tapAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    [view addSubview:titleLabel];
    [view addSubview:arrowView];
    [view addSubview:lineView];
    [view addSubview:actionBtn];
    
    arrowView.hidden = !showArrow;
    lineView.hidden = !showBottomLine;
    
    if (valueView) {
        [view addSubview:valueView];
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALE(11));
        make.centerY.mas_equalTo(0);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SCALE(15));
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCALE(7), SCALE(13)));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.inset(SCALE(7));
        make.height.mas_equalTo(1);
    }];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    if (valueView) {
        [valueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SCALE(38));
            make.centerY.mas_equalTo(0);
            if ([valueView isKindOfClass:UILabel.class]) {
                make.left.greaterThanOrEqualTo(titleLabel.mas_right).offset(SCALE(20));
            } else if ([valueView isKindOfClass:UIImageView.class]) {
                make.size.mas_equalTo(SCALE(32));
            }
        }];
    }

    return view;
}

#pragma mark - setter


#pragma mark - action

- (void)showAvatarPicker {
    [self showImagePickerController];
}

- (void)showGenerPicker {
    StringsPickerPopupView *view = [[StringsPickerPopupView alloc] initWithTitle:@"请选择性别" dataArray:@[@"男", @"女"] defaultString:@"男"];
    view.selectedString = self.genderLabel.text;
    WEAK_SELF
    view.resultBlock = ^(NSString * _Nonnull result, NSInteger index) {
        STRONG_SELF
        self.genderLabel.text = result;
    };
    [view slideFromBottom];
}

- (void)showBirthdayPicker {
    DatePickerPopupView *view = [[DatePickerPopupView alloc] init];
    view.headerTitle = @"选择生日";
    view.selectDate = [NSDate dateWithString:self.birthdayLabel.text format:@"yyyy-MM-dd"];
    view.maxDate = [NSDate date];
    WEAK_SELF
    view.dateSelectedBlock = ^(NSDate * _Nonnull date) {
        STRONG_SELF
        self.birthdayLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
    };
    [view slideFromBottom];
}

- (void)logoutBtnAction:(UIButton *)sender {
    [AppManager.shared accountLogout];
}

#pragma mark - notification


#pragma mark - api


#pragma mark - public


#pragma mark - private

- (void)showImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:(id<TZImagePickerControllerDelegate>)self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.allowCameraLocation = NO;
    imagePickerVc.allowPreview = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT / 2.0 - SCREEN_WIDTH / 2.0, SCREEN_WIDTH, SCREEN_WIDTH);
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.iconThemeColor = COLOR_HEX(#FD6691);
//    imagePickerVc.takePictureImage = IMAGE(@"icon_camera_white_52_48");
    imagePickerVc.photoDefImage = IMAGE(@"icon_image_unselect_21");
    imagePickerVc.photoSelImage = IMAGE(@"icon_image_selected_21");
    imagePickerVc.photoOriginDefImage = IMAGE(@"icon_image_unselect_16");
    imagePickerVc.photoOriginSelImage = IMAGE(@"icon_image_selected_16");
    imagePickerVc.photoPreviewOriginDefImage = IMAGE(@"icon_image_unselect_16");
    imagePickerVc.doneBtnTitleStr = @"确定";
//    imagePickerVc.oKButtonTitleColorNormal = COLOR_HEX(#FFFFFF);
//    imagePickerVc.oKButtonTitleColorDisabled = COLOR_HEX(#FFFFFF);
    imagePickerVc.oKButtonTitleColorNormal = COLOR_HEX(#FD6691);
    imagePickerVc.oKButtonTitleColorDisabled = [COLOR_HEX(#FD6691) colorWithAlphaComponent:0.3];
    imagePickerVc.photoNumberIconImage = [[UIImage imageWithColor:COLOR_HEX(#FD6691) size:CGSizeMake(24, 24)] imageByRoundCornerRadius:12];
    
    imagePickerVc.naviBgColor = NAVI_BAR_COLOR;
    imagePickerVc.naviTitleColor = NAVI_BAR_TITLE_COLOR;
    imagePickerVc.naviTitleFont = NAVI_BAR_TITLE_FONT;
    imagePickerVc.barItemTextColor = COLOR_HEX(#FD6691);
//    imagePickerVc.barItemTextFont = FONT(0);
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        originalPhotoButton.hidden = YES;
        
//        collectionView.backgroundColor = UIColor.redColor;
        
//        numberLabel.hidden = YES;
//        numberImageView.hidden = YES;
//
//        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
//        doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
//        doneButton.backgroundColor = COLOR_HEX(#FD6691);
//        [doneButton setCornerRadius:3];
    }];
    [imagePickerVc setPhotoPickerPageDidLayoutSubviewsBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
//        numberLabel.hidden = YES;
//        numberImageView.hidden = YES;
//        doneButton.size = CGSizeMake(89, 34);
//        doneButton.right = bottomToolBar.width - 9;
//        doneButton.centerY = previewButton.centerY;
    }];
    [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
        [leftButton setImage:NAVI_BAR_BACK_IMAGE forState:UIControlStateNormal];
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    }];
    [imagePickerVc setPhotoPreviewPageUIConfigBlock:^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        
        naviBar.backgroundColor = UIColor.whiteColor;
        toolBar.backgroundColor = UIColor.whiteColor;
        
        [backButton setImage:NAVI_BAR_BACK_IMAGE forState:UIControlStateNormal];
        
        [originalPhotoButton setTitleColor:COLOR_HEX(#818181) forState:UIControlStateNormal];
        [originalPhotoButton setTitleColor:COLOR_HEX(#818181) forState:UIControlStateSelected];
        
        originalPhotoLabel.textColor = COLOR_HEX(#818181);
    }];
    [imagePickerVc setPhotoPreviewPageDidLayoutSubviewsBlock:^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        originalPhotoButton.centerX = toolBar.width / 2.0;
        
        UILabel *titleLabel = [UILabel labelWithColor:NAVI_BAR_TITLE_COLOR font:NAVI_BAR_TITLE_FONT text:@"预览"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(naviBar.width / 2.0, backButton.centerY);
        [naviBar addSubview:titleLabel];
    }];
    [imagePickerVc setAssetCellDidLayoutSubviewsBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
//        cell.
        UICollectionViewCell *aCell = (UICollectionViewCell *)cell;
        aCell.backgroundColor = UIColor.redColor;
        aCell.contentView.backgroundColor = UIColor.redColor;
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (photos.count == 0) {
        return;
    }

    UIImage *image = photos.firstObject;
    image = [image imageByResizeToSize:CGSizeMake(120, 120)];
    self.avatarView.image = image;
}

@end
