//
//  GWUserAnnotationView.m
//  GWMain
//
//  Created by ANNA on 10-7-14.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "GWUserAnnotationView.h"

#define kBusyBeeSize 10
#define kLogoBusyBeeSize 12.0

@implementation GWUserAnnotationView
@synthesize memberid = _memberid;

- (void)requestLogo:(NSString *)logo
{	
	
//	UIImage* image = [[GWImageCache defaultCache] requestor:self imageUrl:logo];
//	if ( nil == image )
//	{			
//		self.image = [BudleImageCache imageNamed:@"default.jpg"];
//		//[self showBusyBeeAtCenter:kLogoBusyBeeSize];
//	}
//	else
//	{
//		self.image = image;
//	}
}

#pragma mark -
#pragma mark GWImageCache delegate
- (void)didRecievedImage:(UIImage *)image forUrl:(NSString *)url
{
	UIImageView* imageView = [_viewDict objectForKey:url];
	imageView.image = image;
	[_imageDict removeObjectForKey:url];
	[_viewDict removeObjectForKey:url];
}

- (void)didRunIntoError:(NSError *)error forUrl:(NSString *)url
{
	[_imageDict removeObjectForKey:url];
	[_viewDict removeObjectForKey:url];
}

- (void) dealloc
{
	[_imageDict release];
	[_viewDict release];
	[super dealloc];

}

@end
