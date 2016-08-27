//
//  GWXMLDeserializer.m
//  WNSoap
//
//  Created by ben on 3/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GWXMLDeserializer.h"
#import "GWXMLDeserializerParserDelegates.h"
#import <objc/runtime.h>
typedef struct propertyListNode {
	objc_property_t *list;
	unsigned int count;
	struct propertyListNode *next;
} *propertyListNode_t;

//static NSString * const TypeAttrivuteName = @"xsi:type";


@implementation GWXMLDeserializer

- (id)init
{
	return nil;
}

- (id)initWithClass:(Class)class parser:(NSXMLParser *)parser elementName:(NSString *)elementName
{
	if(!class || !parser)
	{
		[self release];
		return nil;
	}
	
	self = [super init];
	if(self)
	{
		self->_instanceLock = [[NSLock alloc] init];
		self->_class = [class retain];
		self->_parser = [parser retain];
		self->_parser.delegate = self;
		self->_parser.shouldProcessNamespaces = YES;
		self->_result = nil;
		
		if(elementName)
		{
			self->_elementName = [elementName retain];
		}
		else
		{
			self->_elementName = [[NSString stringWithUTF8String:class_getName(class)] retain];
		}
			
		self->_status = GWXMLDeserializerStatusInited;
	}
	
	return self;
}

- (id)initWithClass:(Class)class xmlData:(NSData *)xmlData elementName:(NSString *)elementName
{
	if(!xmlData)
	{
		[self release];
		return nil;
	}
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	self = [self initWithClass:class parser:parser elementName:elementName];
	
	[parser release];
	return self;
}

- (id)deserialize
{
	id result = nil;
	
	[self->_instanceLock lock];
	
	if(self->_status == GWXMLDeserializerStatusInited)
	{
		self->_status = GWXMLDeserializerStatusDeserializing;
		
		NSAutoreleasePool *releasePool = [[NSAutoreleasePool alloc] init];
		[self->_parser parse];
		
		if(self->_result)
		{
			self->_status = GWXMLDeserializerStatusDeserializationDone;
		}
		else
		{
			self->_status = GWXMLDeserializerStatusDeserializationFailed;
		}
		
		[releasePool release];
	}
	
	if(self->_status == GWXMLDeserializerStatusDeserializationDone)
	{
		result = self->_result;
	}
	
	[self->_instanceLock unlock];

	return result;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
{
	if([elementName isEqualToString:self->_elementName])
	{
		GWXMLDeserializerParserObjectDelegate *objectDelegate = 
		[[[GWXMLDeserializerParserObjectDelegate alloc] initWithSupperDelegate:self elementName:elementName class:self->_class] autorelease];
		parser.delegate = objectDelegate;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
{
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
// The parser reports ignorable whitespace in the same way as characters it's found.
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
// ...and this reports a fatal error to the delegate. The parser will stop parsing.
{
}

- (void)setDeserializedObjectValue:(id)value
{
	if (self->_result != nil)
		[self->_result release];
	self->_result = [value retain];
	// now the parsing is done for the element. however abortParsing will invoke the pars error.
	[self->_parser abortParsing];
}

- (void)dealloc
{
	[self->_parser release];
	[self->_class release];
	[self->_instanceLock release];
	[self->_result release];
	[self->_elementName release];
	[self->_properties release];
	
	[super dealloc];
}

@end
