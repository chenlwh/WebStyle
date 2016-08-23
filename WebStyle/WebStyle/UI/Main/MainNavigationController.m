//
//  MainNavigationController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "MainNavigationController.h"
#import "Constants.h"

@interface MainNavigationController()

@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation MainNavigationController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    /*
     关于interactivePopGestureRecognizer的作用  http://blog.sina.com.cn/s/blog_8c87ba3b0102vgo5.html
     */
    self.interactivePopGestureRecognizer.delegate = nil;
    
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0)
    {
        UIViewController *vc = self.childViewControllers[0];
        
        if(self.childViewControllers.count == 1)
        {
            [self.backBtn setTitle:vc.tabBarItem.title forState:UIControlStateNormal];
        }
        else
        {
            [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
        }
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        viewController.hidesBottomBarWhenPushed = true;
    }
    [super pushViewController:viewController animated:animated];
}

-(UIButton*)backBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    CGFloat btnW = [Constants AppWidth] > 375 ? 50 : 44;
    backBtn.frame = CGRectMake(0, 0, btnW, 40);
    return backBtn;
}

-(void)backBtnClick
{
    [self popViewControllerAnimated:true];
}
@end
