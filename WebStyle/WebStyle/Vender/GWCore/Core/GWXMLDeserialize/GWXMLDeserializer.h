//
//  GWXMLDeserializer.h
//  WNSoap
//
//  Created by ben on 3/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GWXMLDeserializerStatusInited,
	GWXMLDeserializerStatusDeserializing,
	GWXMLDeserializerStatusDeserializationDone,
	GWXMLDeserializerStatusDeserializationFailed
} GWXMLDeserializerStatus;

@interface GWXMLDeserializer : NSObject <NSXMLParserDelegate>{
	Class _class;
	NSXMLParser *_parser;
	NSString *_elementName;
	id _result;
	NSLock *_instanceLock;
	GWXMLDeserializerStatus _status;
	NSDictionary *_properties;
}

- (id)initWithClass:(Class)class parser:(NSXMLParser *)parser elementName:(NSString *)elementName;
- (id)initWithClass:(Class)class xmlData:(NSData *)xmlData elementName:(NSString *)elementName;
- (id)deserialize;

@end
