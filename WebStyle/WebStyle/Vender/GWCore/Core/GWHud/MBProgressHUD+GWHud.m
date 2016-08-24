//
//  MBProgressHUD+GWHud.m
//  GWV2
//
//  Created by yang xueya on 9/5/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import "MBProgressHUD+GWHud.h"
#import "BudleImageCache.h"

@implementation MBProgressHUD (GWHud)


-(void)setCustomViewCheckMark:(NSString *)checkStr
{
    self.mode=MBProgressHUDModeCustomView;
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[BudleImageCache imageNamed:@"hint_check.png"]] autorelease];
    imageView.frame=CGRectMake(60, 0, 30, 30);
    
    if (checkStr.length>8) {
        UIView *v=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 70)] autorelease];
        [v addSubview:[self loadLabel:checkStr]];
 
        [v addSubview:imageView];
        self.customView = v;
    }
    else {
        self.customView=imageView;
        self.labelText=checkStr;
    }
    

}

-(void)setCustomViewretry:(NSString *)retryStr{
    self.mode=MBProgressHUDModeCustomView;
    
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[BudleImageCache imageNamed:@"hint_retry.png"]] autorelease];
    imageView.frame=CGRectMake(60, 5, 30, 30);
    

    if (retryStr.length>8) {
        UIView *v=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)] autorelease];
        
        [v addSubview:[self loadLabel:retryStr]];
        [v addSubview:imageView];
        self.customView = v;
    }
    else {
        self.customView=imageView;
        self.labelText=retryStr;
    }
    
    
}
-(void)setCustomViewSuccess:(NSString *)successStr{
    self.mode=MBProgressHUDModeCustomView;
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[BudleImageCache imageNamed:@"hint_sucess.png"]] autorelease];
    imageView.frame=CGRectMake(60, 5, 30, 30);
    if (successStr.length>8) {
        UIView *v=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)] autorelease];
        
        [v addSubview:[self loadWidthLabel:successStr]];
        imageView.frame = CGRectMake(65, 5, 30, 30);
        [v addSubview:imageView];
        self.customView = v;
    }
    else {
        self.customView=imageView;
        self.labelText=successStr;
    }
    
}

-(void)setCustomViewAddSuccess:(NSString *)Labeltext detailsLabel:(NSString *)dedetailsLabel{

    self.mode=MBProgressHUDModeCustomView;
    UIView *v=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)] autorelease];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[BudleImageCache imageNamed:@"hint_sucess.png"]] autorelease];
    imageView.frame=CGRectMake(60, -10, 30, 30);
    [v addSubview:imageView];
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(40, 15, 80, 40)] autorelease];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textColor=[UIColor whiteColor];
    label.text=Labeltext;
    [v addSubview:label];
    
    UILabel *dedetails=[[[UILabel alloc] initWithFrame:CGRectMake(-5, 50, 160, 40)] autorelease];
    dedetails.backgroundColor=[UIColor clearColor];
    dedetails.font=[UIFont systemFontOfSize:14];
    dedetails.textColor=[UIColor whiteColor];
    dedetails.textAlignment = NSTextAlignmentCenter;  
    dedetails.lineBreakMode = NSLineBreakByWordWrapping;
    dedetails.numberOfLines = 0; 
    dedetails.text=dedetailsLabel;
    [v addSubview:dedetails];
    
    self.customView=v;
    
    


}

-(UILabel *)loadLabel:(NSString *)labelTitle{
    
    UILabel *_label=[[[UILabel alloc] initWithFrame:CGRectMake(5, 40, 140, 60)] autorelease];
    _label.textColor=[UIColor whiteColor];
    _label.backgroundColor=[UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;  
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0; 
    _label.font=[UIFont boldSystemFontOfSize:14];
    _label.text=labelTitle;
    return _label;
}

- (UILabel *)loadWidthLabel:(NSString *)labelTitle{
    UILabel *_label=[[[UILabel alloc] initWithFrame:CGRectMake(5, 35, 150, 60)] autorelease];
    _label.textColor=[UIColor whiteColor];
    _label.backgroundColor=[UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0;
    _label.font=[UIFont boldSystemFontOfSize:14];
    _label.text=labelTitle;
    return _label;
}

@end
