//
//  YDMYDMEmptyDataSetManager.m
//  yidianMedicine
//
//  Created by wangxun on 2020/3/20.
//  Copyright © 2020 com.haiwang.www. All rights reserved.
//

#import "YDMEmptyDataSetManager.h"
#import <objc/runtime.h>

static YDMEmptyDataSetManager *manager = nil;

@implementation YDMEmptyDataSetManager

+(instancetype)emptyDataSetWithImage:(UIImage *)image
                               title:(NSString *)title
                             message:(NSString *)message
                         buttonTitle:(NSString *)buttonTitle {
    YDMEmptyDataSetManager *manager = [[YDMEmptyDataSetManager alloc] init];
    [manager updateEmptyDataSetImage:image title:title message:message buttonTitle:buttonTitle];
    return manager;
}

-(void)updateEmptyDataSetImage:(UIImage *)image
                         title:(NSString *)title
                       message:(NSString *)message
                   buttonTitle:(NSString *)buttonTitle {
    self.image = image;
    self.title = title;
    self.message = message;
    self.buttonTitle = buttonTitle;
}


-(instancetype)init {
    self = [super init];
    if (self && manager) {
        [self initializes];
    }
    return self;
}

-(void)initializes {
    self.image = [YDMEmptyDataSetManager appearance].image;
    self.imageTintColor = [YDMEmptyDataSetManager appearance].imageTintColor;
    self.imageAnimation = [YDMEmptyDataSetManager appearance].imageAnimation;
    
    self.title       = [YDMEmptyDataSetManager appearance].title;
    self.message     = [YDMEmptyDataSetManager appearance].message;
    self.buttonTitle = [YDMEmptyDataSetManager appearance].buttonTitle;
    self.titleAttibutes        = [YDMEmptyDataSetManager appearance].titleAttibutes;
    self.messageAttributes     = [YDMEmptyDataSetManager appearance].messageAttributes;
    self.buttonTitleAttributes = [YDMEmptyDataSetManager appearance].buttonTitleAttributes;
    
    self.buttonImage = [YDMEmptyDataSetManager appearance].buttonImage;
    self.buttonBackgroudImage = [YDMEmptyDataSetManager appearance].buttonBackgroudImage;
    
    self.spaceHeight     = [YDMEmptyDataSetManager appearance].spaceHeight;
    self.verticalOffset  = [YDMEmptyDataSetManager appearance].verticalOffset;
    self.backgroundColor = [YDMEmptyDataSetManager appearance].backgroundColor;
    
    
    self.shouldDisplay = [YDMEmptyDataSetManager appearance].shouldDisplay;
    self.shouldAllowScroll  = [YDMEmptyDataSetManager appearance].shouldAllowScroll;
    self.shouldAllowTouch   = [YDMEmptyDataSetManager appearance].shouldAllowTouch;
    self.shouldFadeIn       = [YDMEmptyDataSetManager appearance].shouldFadeIn;
    self.shouldAnimateImage = [YDMEmptyDataSetManager appearance].shouldAnimateImage;
    self.shouldBeForcedToDisplay = [YDMEmptyDataSetManager appearance].shouldBeForcedToDisplay;
    
    self.customView     = [YDMEmptyDataSetManager appearance].customView;
    self.showCustomView = [YDMEmptyDataSetManager appearance].showCustomView;
}

#pragma mark --- DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
// image
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.image;
}

-(UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageTintColor;
}

-(CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageAnimation;
}

// title
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.title.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.title attributes:self.titleAttibutes];
    }
    return nil;
}

// description
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.message.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.message attributes:self.messageAttributes];
    }
    return nil;
    
}

// button
-(UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return self.buttonImage;
}

-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return self.buttonBackgroudImage;
}

-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.buttonTitle.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.buttonTitle attributes:self.buttonTitleAttributes];
    }
    return nil;
}

// contents
-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.spaceHeight;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

-(UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.backgroundColor;
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    //    if (self.showCustomView) {
    //        return self.customView;
    //    }
    //    return nil;
    
    YDMEmptyDataView *emptyDataView = [YDMEmptyDataView emptyDataViewWithTitle:self.title  buttonTitle:self.buttonTitle image:self.image];
    [emptyDataView.tapButton addTarget:self action:@selector(tapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
    }];
    return emptyDataView;
}

/// delegate
-(BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return self.shouldFadeIn;
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.shouldDisplay;
}

-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return self.shouldAllowTouch;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return self.shouldAllowScroll;
}

-(BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.shouldAnimateImage;
}

-(BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return self.shouldBeForcedToDisplay;
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    !self.emptyDataSetTapView?:self.emptyDataSetTapView(scrollView, view, self);
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    !self.emptyDataSetTapButton?:self.emptyDataSetTapButton(scrollView, button, self);
}

- (void)tapButtonClick:(UIButton *)button{
    !self.emptyDataSetTapButton?:self.emptyDataSetTapButton(nil, button, self);
}
@end


@implementation YDMEmptyDataSetManager (Appearance)

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self appearance];
    });
}

+(instancetype)appearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[YDMEmptyDataSetManager alloc] init];
            
            manager.titleAttibutes        = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName:[UIColor lightGrayColor]};
            manager.messageAttributes     = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName:[UIColor lightGrayColor]};
            manager.buttonTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName:[UIColor lightGrayColor]};
            
            manager.spaceHeight     = 11;
            manager.verticalOffset  = 0;
            manager.backgroundColor = BASE_BACKGROUND_COLOR;
            
            manager.shouldDisplay = YES;
            manager.shouldAllowScroll  = NO;
            manager.shouldAllowTouch   = YES;
            manager.shouldFadeIn       = YES;
            manager.shouldAnimateImage = NO;
            manager.shouldBeForcedToDisplay = NO;
            manager.showCustomView = YES;
        }
    });
    return manager;
}
@end

static NSString *emptyDataTypeKey = @"emptyDataType";
@implementation YDMEmptyDataSetManager (EmptyDataType)
- (YDMEmptyDataType)emptyDataType{
    NSNumber *emptyTypeValue = objc_getAssociatedObject(self, &emptyDataTypeKey);
    return [emptyTypeValue intValue];
}

- (void)setEmptyDataType:(YDMEmptyDataType)emptyDataType{
    objc_setAssociatedObject(self, &emptyDataTypeKey, @(emptyDataType), OBJC_ASSOCIATION_ASSIGN);
    [self setupDataType:emptyDataType];
}

- (void)setupDataType:(YDMEmptyDataType)emptyDataType{
    switch (emptyDataType) {
            
        case YDMEmptyDataTypeLoading:
        {
            self.shouldDisplay = NO;
        }
            break;
        case YDMEmptyDataTypeLoadFailue:
        {
            self.shouldDisplay = YES;
            self.title = @"加载失败，请稍后再试";
            self.message = @"";
            self.buttonTitle = @"重新加载~";
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeNetWorkLost:
        {
            self.shouldDisplay = YES;
            self.title = @"网络丢失啦~";
            self.message = @"";
            self.buttonTitle = @"重新加载~";
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeShoppingCartNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"当前暂无预约，快去逛逛吧~";
            self.buttonTitle = @"";
            //            self.buttonImage = [UIImage imageNamed:@"toAdd"];
            self.image = [UIImage imageNamed:@"预约清单空占位"];
        }
            break;
        case YDMEmptyDataTypeNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无数据";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeMyCouponNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无卡券";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无卡券占位"];
        }
            break;
        case YDMEmptyDataTypeBaoDanNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无保单";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无保单占位"];
        }
            break;
        case YDMEmptyDataTypeMyPrescriptionNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"您还没有相关处方信息~";
            self.message = @"";
            self.buttonTitle = @"去添加";
            //self.buttonImage = [UIImage imageNamed:@"toAdd"];
            self.image = [UIImage imageNamed:@"处方无数据占位"];
        }
            break;
        case YDMEmptyDataTypeMyNeedsNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无数据";
            self.message = @"";
            self.buttonTitle = @"";
            //            self.buttonImage = [UIImage imageNamed:@"toAdd"];
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeCategoryNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无数据";
            self.message = @"";
            self.buttonTitle = @"去添加";
            //self.buttonImage = [UIImage imageNamed:@"reLoad"];
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeMyMessageCenterNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无消息";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
            break;
        case YDMEmptyDataTypeMyCollectNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"当前没有收藏哦~";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无收藏占位"];
        }
            break;
        case YDMEmptyDataTypeSearchNoResult:
        {
            self.shouldDisplay = YES;
            self.title = @"没有搜索到你想要的，换个关键词吧~";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"搜索关键字占位"];
        }
            break;
        case YDMEmptyDataTypeStoreSearchNoResult:
        {
            self.shouldDisplay = YES;
            self.title = @"此店铺没有该药品，尝试搜索其他店铺吧~ ";
            self.message = @"";
            self.buttonTitle = @"立即前往";
            self.image = [UIImage imageNamed:@"搜索关键字占位"];
        }
            break;
        case YDMEmptyDataTypeMemberCenterNoData:
        {
            self.shouldDisplay = YES;
            self.title = @"您还没有加入店铺会员哦~";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"会员店铺无数据占位"];
        }
            break;
        case YDMEmptyDataTypeSearchNoAddressResult:
        {
            self.shouldDisplay = YES;
            self.title = @"没有搜索到相关信息";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"搜索不到地址占位"];
        }
            break;
            
        case YDMEmptyDataTypeNoInfo:
        {
            self.shouldDisplay = YES;
            self.title = @"暂无信息";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无信息占位"];
        }
            break;
            
        case YDMEmptyDataTypeHomeNearStoreNoData:{
            self.shouldDisplay = YES;
            self.title = @"附近10公里范围内暂无预约门店，我们正在积极开拓中...";
            self.message = @"";
            self.buttonTitle = @"";
            self.image = [UIImage imageNamed:@"暂无数据占位"];
        }
        default:
            break;
    }
    
    NSMutableDictionary *buttonDictM = [NSMutableDictionary dictionary];
    buttonDictM[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    buttonDictM[NSForegroundColorAttributeName] = [UIColor redColor];
    self.buttonTitleAttributes = buttonDictM;
}
@end

@interface YDMEmptyDataView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UIImage *image;
@end

@implementation YDMEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.tapButton];
    }
    return self;
}
+ (instancetype)emptyDataViewWithTitle:(NSString *)title
                           buttonTitle:(NSString *)buttonTitle
                                 image:(UIImage *)image{
    YDMEmptyDataView *emptyDataView = [[YDMEmptyDataView alloc]init];
    emptyDataView.titleLabel.text = title;
    emptyDataView.imageView.image = image;
    //    emptyDataView.imageView.backgroundColor = [UIColor redColor];
    [emptyDataView.tapButton setTitle:buttonTitle forState:UIControlStateNormal];
    emptyDataView.tapButton.hidden = !buttonTitle.length;
    return emptyDataView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        //        make.centerY.mas_equalTo(self.mas_centerY).offset(-30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.imageView.mas_bottom);
    }];
    
    [self.tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 32));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UIButton *)tapButton{
    if (!_tapButton) {
        _tapButton = [[UIButton alloc]init];
        _tapButton.backgroundColor = [UIColor whiteColor];
        [_tapButton setTitleColor:BASE_RED_COLOR forState:UIControlStateNormal];
        _tapButton.layer.cornerRadius = 16;
        _tapButton.layer.masksToBounds = YES;
        _tapButton.layer.borderColor = BASE_RED_COLOR.CGColor;
        _tapButton.layer.borderWidth = 0.5;
        _tapButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tapButton;
}
@end
