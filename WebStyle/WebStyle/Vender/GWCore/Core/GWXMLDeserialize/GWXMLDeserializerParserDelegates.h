//
//  GWXMLDeserializerParserDelegates.h
//  WNSoap
//
//  Created by ben on 3/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@protocol GWXMLDeserializerParserDelegate

@required
- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName; 
@property ( retain, readonly) id<GWXMLDeserializerParserDelegate> superDelegate;

@optional
- (void)setDeserializedLongLongValue:(long long)value;
- (void)setDeserializedLongValue:(long)value;
- (void)setDeserializedObjectValue:(id)value;
- (void)setDeserializedShortValue:(short)value;
- (void)setDeserializedIntValue:(int)value;
- (void)setDeserializedBoolValue:(BOOL)value;
- (void)setDeserializedDoubleValue:(double)value;

@end

@interface GWXMLDeserializerParserDelegate : NSObject <GWXMLDeserializerParserDelegate,NSXMLParserDelegate>
{
	id _superDelegate;
	NSString *_elementName;
	NSMutableString *_currentString;
}

+ (Class)classFromName:(NSString *)name; 
@end

@interface GWXMLDeserializerParserLongLongDelegate : GWXMLDeserializerParserDelegate
{
}

@end

@interface GWXMLDeserializerParserShortDelegate : GWXMLDeserializerParserDelegate
{
}

@end

@interface GWXMLDeserializerParserIntDelegate : GWXMLDeserializerParserDelegate
{
}
@end

@interface GWXMLDeserializerParserBoolDelegate : GWXMLDeserializerParserDelegate
{
	
}
@end


@interface GWXMLDeserializerParserLongDelegate : GWXMLDeserializerParserDelegate
{
}

@end

@interface GWXMLDeserializerParserDoubleDelegate : GWXMLDeserializerParserDelegate
{
}

@end

@interface GWXMLDeserializerParserNSStringDelegate : GWXMLDeserializerParserDelegate
{
}

@end

@interface GWXMLDeserializerParserObjectDelegate : GWXMLDeserializerParserDelegate
{
	Class _class;
	id _i_result;
	NSDictionary *_properties;
	IMP _currentSetter;
	SEL _currentSelector;
}

- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName class:(Class)class;

@end


@interface GWXMLDeserializerParserNSArrayDelegate : GWXMLDeserializerParserDelegate
{
	NSMutableArray *_array;
}

@end


@interface GWXMLDeserializerParserNSDateDelegate : GWXMLDeserializerParserDelegate
{
	
}

@end

