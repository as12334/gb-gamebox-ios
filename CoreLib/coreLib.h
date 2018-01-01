//
//  coreLib.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#ifndef coreLib_h
#define coreLib_h

#import "help.h"
#import "MacroDef.h"
#import "ScreenAdaptation.h"

#pragma mark-扩展相关
#import "NSData+Base64.h"
#import "NSDate+CLCategory.h"
#import "NSDictionary+CLCategory.h"
#import "NSObject+ShowViewControllerDelegate.h"
#import "NSObject+IntervalAnimation.h"
#import "NSString+Base64.h"
#import "NSString+Hash.h"
#import "NSString+CLCategory.h"
#import "NSURL+CLCategory.h"
#import "UIAlertView+Block.h"
#import "UIActionSheet+Block.h"
#import "UIColor+HexString.h"
#import "UIFont+CLCategory.h"
#import "UIImage+Alpha.h"
#import "UIImage+Size.h"
#import "UIImage+Orientation.h"
#import "UIImage+Tint.h"
#import "UIImage+Representation.h"
#import "UILabel+CalculateShowSize.h"
#import "UIView+IntervalAnimation.h"
#import "UIView+FrameSize.h"
#import "UIView+Instance.h"
#import "UIViewController+DesignatedShow.h"
#import "UIViewController+Instance.h"
#import "UITableView+Register.h"
#import "UITableViewCell+ShowContent.h"
#import "UICollectionView+Register.h"
#import "UICollectionReusableView+ShowContent.h"
#import "UIViewController+CLTabBarController.h"
#import "UIScrollView+ScrollToBorder.h"

#pragma MARK-网络相关
#import "CLHTTPRequest.h"
#import "CLFormDataHTTPRequest.h"
#import "CLNetReachability.h"
#import "CLWeakDelegate.h"
#import "URLConnectionManager.h"
//#import "URLSessionManager.h"

#pragma MARK-类定义
#import "CLSelectionProtocol.h"
#import "CLBorderProtocol.h"
#import "CLLineLayer.h"
#import "CLBorderView.h"
#import "CLSelectionView.h"
#import "CLBadgeView.h"
#import "CLContentView.h"
#import "CLGradientView.h"
#import "CLTableViewCell.h"
#import "CLCollectionViewCell.h"
#import "CLMaskView.h"
#import "CLActivityIndicatorView.h"
#import "CLIndicateView.h"
#import "CLLoadingIndicateView.h"
#import "CLTabBarController.h"
#import "CLViewController.h"
#import "CLBasicViewController.h"
#import "CLStaticCollectionViewTitleCell.h"
#import "CLTableViewManagement.h"
#import "CLTextField.h"
#import "CLHeaderTitleView.h"
#import "CLSectionControl.h"
#import "CLDeclineMenu.h"
#import "CLDocumentCachePool.h"
#import "CLCalendarView.h"
#import "CLTextView.h"
#import "CLContentTextInputView.h"
#import "CLImagePickerViewController.h"
#import "CLMultipleImagePickerController.h"
#import "CLContentViewForCell.h"
#import "UIImage+UPload.h"
#import "CLButton.h"
#import "CircleProgressView.h"
#import "UIImageView+WebCache.h"
#import "CLLabel.h"
#import "MJExtension.h"
#import "CLNavigationBar.h"
#import "CLImageTitleStaticCollectionViewCell.h"
#import "KIPageView.h"
#import "CLSegmentedControl.h"
#import "CLSelectionControl.h"

#pragma Mark-pageview
#import "CLPageView.h"
#import "CLScrollContentPageCell.h"
#import "CLPageLoadContentPageCell.h"

#pragma Mark-图片浏览
#import "CLScanImageData.h"
#import "CLScanImageView.h"

#pragma MARK-
#import "CLAPPDelegate.h"
#import "CLUserGuideView.h"
#import "CLUserGuidePageManager.h"

#pragma MARK-组件类
#import "CLStaticCollectionView.h"
#import "CLStaticCollectionViewCell.h"
#import "CLArrayPageLoadController.h"
#import "CLSectionArrayPageLoadController.h"
#import "CLPageLoadManagerForTableAndCollectionView.h"

#pragma MARK-侧划
#import "UIViewController+CWLateralSlide.h"

#pragma MARK-
#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"

#pragma MARK-indicatorView
#import "CLActivityIndicatorView.h"
#import "CLRefreshControl.h"


#endif /* coreLib_h */
