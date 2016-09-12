//
//  GWPasswordFindView.h
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLoginBaseControl.h"
@protocol GWPasswordFindViewDelegate <NSObject>
@optional
-(void)getCheckNumber;
-(void)passwordBackClicked;
-(void)passwordFinish;
-(void)changeStatus:(BOOL)status;
-(void)beginEdit:(UITextField*)field;
@end

@interface GWPasswordFindView : GWLoginBaseControl <UITextFieldDelegate>
{

}
@property (weak, nonatomic) id <GWPasswordFindViewDelegate> deletgate;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *checkField;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *quickEnterButton;
+(GWPasswordFindView*)createView:(CGRect)frame;
-(void)resignALL;
-(BOOL)checkTextLength;
-(void)changeButtonStatus:(BOOL)enable;
@end
