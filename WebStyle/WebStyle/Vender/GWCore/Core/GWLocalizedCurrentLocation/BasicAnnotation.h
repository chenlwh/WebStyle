//
//  BasicAnnotation.h
//  GWV2
//
//  Created by xueya yang on 2/27/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D	_coordinate;
	
	NSString*	_annoTitle;
	NSString*	_annoSubtitle;
    NSString*   _address;
}

@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* annoTitle;
@property (nonatomic, copy) NSString* annoSubtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
