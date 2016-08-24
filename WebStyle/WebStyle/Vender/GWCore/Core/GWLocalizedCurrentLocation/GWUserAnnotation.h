//
//  GWUserAnnotaion.h
//  GWMain
//
//  Created by ANNA on 10-7-14.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GWUserAnnotation : NSObject <MKAnnotation>
{
	NSString*	_memberid;
	NSString*	_userTitle;
	NSString*	_userSubtitle;
	NSString*	_logo;
	
	CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, copy) NSString* memberid;
@property (nonatomic, copy) NSString* userTitle;
@property (nonatomic, copy) NSString* userSubtitle;
@property (nonatomic, copy) NSString* logo;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
