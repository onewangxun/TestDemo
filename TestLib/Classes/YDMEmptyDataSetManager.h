//
//  YDMEmptyDataSetManager.h
//  yidianMedicine
//
//  Created by wangxun on 2020/3/20.
//  Copyright © 2020 com.haiwang.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

NS_ASSUME_NONNULL_BEGIN

/*
 实际开发中，要根据需求来实现。
 一般情况下流程：
 1、进入带有tableView的界面，开始进行网络请求。此时：一般显示customView。设置为加载提示（demo中设置的全局的UIActivityIndicatorView，当然也可以自定义）。注意showCustomView = YES；
 2-1、网络请求成功。此时隐藏customView。showCustomView = NO；
 同时[tableview reloadEmptyDataSet];
 [tableview reloadData]; 不管服务器返回的数据是否为空，都没问题。有数据显示数据，没数据就是显示emptyDateSet。
 2-2、网络请求失败。此时隐藏customView。showCustomView = NO；
 但是失败的原因很多。这就需要根据实际需求来实现。比如如果error.code == -1009 这种情况下是无网络。
 我们只需要 [manager updateEmptyDataSetImage:[UIImage imageNamed:@"no_network"]
 title:@"无网络"
 message:@"查看详情->->"
 buttonTitle:@"重写加载数据"];
 或者显示别的原因等。
 
 如果我们理解DZNEmptyDataSet的工作原理，那么理解起来可能跟容易些。
 
 
 使用:
 
 
 YDMEmptyDataSetManager *emptyManager = [[YDMEmptyDataSetManager alloc]init];
 emptyManager.emptyDataType = YDMEmptyTypeDataGoLogin;
 emptyManager.shouldAllowTouch = YES;
 
 
 //点击背景调用
 emptyManager.emptyDataSetTapView = ^(UITableView * _Nonnull scrollView, UIView * _Nonnull tapView, YDMEmptyDataSetManager * _Nonnull manager) {
 manager.showCustomView = !manager.isShowingCustomView;
 
 //更新显示内容
 [manager updateEmptyDataSetImage:[UIImage imageNamed:@"empty_no_data"] title:@"无网络" message:@"查看详情->->" buttonTitle:@"重写加载数据"];
 manager.titleAttibutes = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:14]};
 [scrollView reloadEmptyDataSet];
 
 };
 
 //点击按钮调用
 emptyManager.emptyDataSetTapButton = ^(__kindof UITableView * _Nonnull scrollView, UIButton * _Nonnull button, YDMEmptyDataSetManager * _Nonnull manager) {
 
 self.loading = NO;
 
 });
 };
 self.tableView.emptyDataSetSource = emptyManager;
 self.tableView.emptyDataSetDelegate = emptyManager;
 
 */


@class YDMEmptyDataSetManager;
typedef void(^EmptyDataSetTapView)(__kindof UIScrollView *scrollView, UIView *tapView, YDMEmptyDataSetManager *manager);
typedef void(^EmptyDataSetTapButton)(__kindof UIScrollView  * __nullable scrollView, UIButton *button, YDMEmptyDataSetManager *manager);

@interface YDMEmptyDataSetManager : NSObject<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

// DZNEmptyDataSetSource
/// 图片
@property(nonatomic, strong) UIImage *image UI_APPEARANCE_SELECTOR;
/// 图片tintColor
@property(nonatomic, strong) UIColor *imageTintColor UI_APPEARANCE_SELECTOR;
/// 图片动画。需要配合shouldAnimateImage一起使用
@property(nonatomic, strong) CAAnimation *imageAnimation UI_APPEARANCE_SELECTOR;

/// 标题
@property(nonatomic, strong) NSString *title UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *titleAttibutes UI_APPEARANCE_SELECTOR;

/// 详细信息
@property(nonatomic, strong) NSString *message UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *messageAttributes UI_APPEARANCE_SELECTOR;

/// 按钮图片
@property(nonatomic, strong) UIImage *buttonImage UI_APPEARANCE_SELECTOR;
/// 按钮背景图片
@property(nonatomic, strong) UIImage *buttonBackgroudImage UI_APPEARANCE_SELECTOR;
/// 按钮文字
@property(nonatomic, strong) NSString *buttonTitle UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *buttonTitleAttributes UI_APPEARANCE_SELECTOR;


/// 竖直方向偏移。默认0
@property(nonatomic, assign) CGFloat verticalOffset UI_APPEARANCE_SELECTOR;
/// 每个控件间的间距。默认11
@property(nonatomic, assign) CGFloat spaceHeight UI_APPEARANCE_SELECTOR;

/// 背景颜色。默认whiteColor
@property(nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/// 自定义view。如果有值，那么上面的属性将会失效。默认nil
@property(nonatomic, strong) UIView *customView UI_APPEARANCE_SELECTOR;
/// 是否显示自定义view。默认YES
@property(nonatomic, assign, getter=isShowingCustomView) BOOL showCustomView UI_APPEARANCE_SELECTOR;

// DZNEmptyDataSetDelegate
/// 是否显示。默认YES。
@property(nonatomic, assign) BOOL shouldDisplay UI_APPEARANCE_SELECTOR;

/// 是否以渐变的形式显示。默认YES
@property(nonatomic, assign) BOOL shouldFadeIn UI_APPEARANCE_SELECTOR;

/// 是否允许点击。默认YES
@property(nonatomic, assign) BOOL shouldAllowTouch UI_APPEARANCE_SELECTOR;

/// 是否能够滚动。默认NO
@property(nonatomic, assign) BOOL shouldAllowScroll UI_APPEARANCE_SELECTOR;

/// 是否旋转image。默认NO。如果想要旋转，imageAnimation 必须有值，同时shouldAnimateImage = YES。
@property(nonatomic, assign) BOOL shouldAnimateImage UI_APPEARANCE_SELECTOR;


/**
 是否强制显示。默认NO
 DZNEmptyDataSet作者的思路是：
 1、只有当-emptyDataSetShouldDisplay返回YES（对应YDMEmptyDataSetManager的属性是shouldDisplay），并且scrolleView的item == 0的时候才会显示。
 2、当-emptyDataSetShouldBeForcedToDisplay对应YDMEmptyDataSetManager的属性是shouldBeForcedToDisplay） 返回YES的时候，也会显示。
 详细代码如下 if (([self dzn_shouldDisplay] && [self dzn_itemsCount] == 0) || [self dzn_shouldBeForcedToDisplay]) { }。
 */
@property(nonatomic, assign) BOOL shouldBeForcedToDisplay UI_APPEARANCE_SELECTOR;



/// 点击view。shouldAllowTouch = YES 才有效
@property(nonatomic, copy)  EmptyDataSetTapView     emptyDataSetTapView;

/// 点击button。 有设置button才有效
@property(nonatomic, copy)  EmptyDataSetTapButton emptyDataSetTapButton;


/**
 初始化
 
 @param image image
 @param title title
 @param message message
 @param buttonTitle buttonTitle
 @return instancetype
 */
+(instancetype)emptyDataSetWithImage:(nullable UIImage *)image
                               title:(nullable NSString *)title
                             message:(nullable NSString *)message
                         buttonTitle:(nullable NSString *)buttonTitle;


/**
 更新内容。配合[scrollView reloadEmptyDataSet]；使用。
 
 @param image image
 @param title title
 @param message message
 @param buttonTitle buttonTitle
 */
-(void)updateEmptyDataSetImage:(nullable UIImage *)image
                         title:(nullable NSString *)title
                       message:(nullable NSString *)message
                   buttonTitle:(nullable NSString *)buttonTitle;
@end

@interface YDMEmptyDataSetManager (Appearance)

+(instancetype)appearance;

@end


//typedef NS_ENUM(NSUInteger, YDMEmptyDataType) {
//    YDMEmptyDataTypeLoadFailue, //数据加载失败
//    YDMEmptyDataTypeNetWorkLost, //网络丢失
//    YDMEmptyDataTypeLoading,  //加载动画中
//    YDMEmptyDataTypeShoppingCartNoData, //购物车无数据
//    YDMEmptyDataTypeNoData, //无数据
//    YDMEmptyDataTypeMyCouponNoData, //无卡券
//    YDMEmptyDataTypeMyPrescriptionNoData, //无处方数据
//    YDMEmptyDataTypeMyNeedsNoData, //暂无预约清单数据
//    YDMEmptyDataTypeCategoryNoData, //药品分类暂无数据
//    YDMEmptyDataTypeMyMessageCenterNoData, //我的消息暂无数据
//    YDMEmptyDataTypeMyCollectNoData, //暂无收藏数据
//    YDMEmptyDataTypeSearchNoResult, //搜索没有结果
//    YDMEmptyDataTypeStoreSearchNoResult, //店铺搜索没有结果
//    YDMEmptyDataTypeNoAuthoLocation,
//    YDMEmptyDataTypeSearchNoAddressResult, //没搜到定位地址
//    YDMEmptyDataTypeBaoDanNoData, //暂无保单
//    YDMEmptyDataTypeNoInfo, //暂无信息
//    YDMEmptyDataTypeMemberCenterNoData, //会员列表无数据
//    YDMEmptyDataTypeHomeNearStoreNoData, //首页附近门店咱无数据
//};

@interface YDMEmptyDataSetManager (EmptyDataType)

@property (nonatomic, assign) YDMEmptyDataType emptyDataType;
@end

@interface YDMEmptyDataView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *tapButton;

+ (instancetype)emptyDataViewWithTitle:(NSString *)title
                           buttonTitle:(NSString *)buttonTitle
                                 image:(UIImage *)image;
@end


NS_ASSUME_NONNULL_END

