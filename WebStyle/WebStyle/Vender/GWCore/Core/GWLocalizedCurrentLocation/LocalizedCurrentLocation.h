#import <Foundation/Foundation.h>

@interface LocalizedCurrentLocation : NSObject {

}

+ (NSString *)currentLocationStringForCurrentLanguage;

+ (NSString *)currentLocalizedLocality:(NSString*)locality;

@end
