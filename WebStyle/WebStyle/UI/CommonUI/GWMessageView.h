//
//  GWMessageView.h
//  GWV2
//
//  Created by yangxueya on 10/14/13.
//
//

#import <UIKit/UIKit.h>


@interface GWMessageView : UIView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *msLabel;
@property (nonatomic, strong) UIButton* retryButton;
@property (assign) BOOL removeFromSuperViewOnRetryButtonClicked;


@property (nonatomic, copy) void(^retryBlock)();

+ (GWMessageView *)showMSGAddedTo:(UIView *)view
                             text:(NSString*)text
                         animated:(BOOL)animated;

+ (GWMessageView *)showMSGAddedTo:(UIView *)view
                             text:(NSString*)text
                          xOffset:(float)xoffset
                          yOffset:(float)yoffset
                         animated:(BOOL)animated;

+ (void)hideMSGForView:(UIView *)view
              animated:(BOOL)animated;



+ (GWMessageView *)show404MSGAddedTo:(UIView *)view
                            animated:(BOOL)animated;



+ (GWMessageView *)showEmptyMsgAddedTo:(UIView *)view
                              withText:(NSString*)emptyText
                              animated:(BOOL)animated;

+ (GWMessageView *)showNoConnectMsgAddedTo:(UIView *)view
                                  withText:(NSString*)emptyText
                                  animated:(BOOL)animated;


+ (GWMessageView *)showErrorMsgAddedTo:(UIView *)view
                         withErrorText:(NSString*)errorText
                              animated:(BOOL)animated
                            retryBlock:(void (^)())retryBlock;

@end
