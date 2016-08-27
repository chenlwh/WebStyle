//
//  GWUserAnnotaion.m
//  GWMain
//
//  Created by ANNA on 10-7-14.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "GWUserAnnotation.h"


@implementation GWUserAnnotation

@synthesize memberid = _memberid;
@synthesize userTitle = _userTitle;
@synthesize userSubtitle = _userSubtitle;
@synthesize logo = _logo;
@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
	if ( self = [super init] )
	{
		_coordinate = coordinate;
	}
	return self;
}

#pragma mark -
#pragma mark MKAnnotation
- (NSString *)title
{
	return _userTitle;
}

- (NSString *)subtitle
{
	return _userSubtitle;
}

- (void)dealloc
{
	[_memberid release];
	[_userTitle release];
	[_userSubtitle release];
	[_logo release];
	
	[super dealloc];
}

@end
