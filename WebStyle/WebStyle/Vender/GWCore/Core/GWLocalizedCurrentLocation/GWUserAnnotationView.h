//
//  GWUserAnnotationView.h
//  GWMain
//
//  Created by ANNA on 10-7-14.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface GWUserAnnotationView : MKAnnotationView 
{	
	NSString*	_memberid;
	NSMutableDictionary* _viewDict;
	NSMutableDictionary* _imageDict;
}

@property (nonatomic, copy) NSString* memberid;

- (void)requestLogo:(NSString *)logo;

@end
