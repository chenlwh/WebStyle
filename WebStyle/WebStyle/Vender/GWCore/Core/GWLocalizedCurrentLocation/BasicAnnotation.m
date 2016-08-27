//
//  BasicAnnotation.m
//  GWV2
//
//  Created by xueya yang on 2/27/13.
//
//

#import "BasicAnnotation.h"

@implementation BasicAnnotation
@synthesize address = _address;
@synthesize annoTitle = _annoTitle;
@synthesize annoSubtitle = _annoSubtitle;
@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
	if ( self = [super init] )
	{
		_coordinate = coordinate;
	}
	return self;
}

- (NSString *)title
{
	return _annoTitle;
}
- (NSString *)subtitle
{
	return _annoSubtitle;
}

- (void)dealloc
{
	[_annoTitle release];
	[_annoSubtitle release];
    [_address release];
	
	[super dealloc];
}
@end
