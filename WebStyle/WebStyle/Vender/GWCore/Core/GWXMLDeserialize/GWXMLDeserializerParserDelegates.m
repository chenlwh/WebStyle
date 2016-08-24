//
//  GWXMLDeserializerParserDelegates.m
//  WNSoap
//
//  Created by ben on 3/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GWXMLDeserializerParserDelegates.h"

typedef struct propertyListNode {
	objc_property_t *list;
	unsigned int count;
	struct propertyListNode *next;
} *propertyListNode_t;

static NSString * const TypeAttrivuteName = @"xsi:type";

typedef void (*charSetter_t)(id, SEL, char);
typedef void (*intSetter_t)(id, SEL, int);
typedef void (*shortSetter_t)(id, SEL, short);
typedef void (*longSetter_t)(id, SEL, long);
typedef void (*longlongSetter_t)(id, SEL, long long);
typedef void (*ucharSetter_t)(id, SEL, unsigned char);
typedef void (*uintSetter_t)(id, SEL, unsigned int);
typedef void (*ushortSetter_t)(id, SEL, unsigned short);
typedef void (*ulongSetter_t)(id, SEL, unsigned long);
typedef void (*ulonglongSetter_t)(id, SEL, unsigned long long);
typedef void (*floatSetter_t)(id, SEL, float);
typedef void (*doubleSetter_t)(id, SEL, double);
typedef void (*cstringSetter_t)(id, SEL, char*);
typedef void (*objectSetter_t)(id, SEL, id);
typedef void (*boolSetter_t)(id, SEL, BOOL);

@implementation GWXMLDeserializerParserDelegate

@synthesize superDelegate = _superDelegate;

+ (Class)classFromName:(NSString *)name
{
    if (![name length]) {
        return NULL;
    }
    
    unichar firstChar = [name characterAtIndex:0];
    if (firstChar >= 'a' 
        && firstChar <= 'z') {
        firstChar = firstChar + ('A' - 'a');
        name = [NSString stringWithFormat:@"%@%@", [NSString stringWithCharacters:&firstChar length:1], [name substringFromIndex:1]];
    }
    
    return NSClassFromString(name);
}

- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName
{
	if(self = [super init])
	{
		self->_superDelegate = [superDelegate retain];
		self->_elementName = [elementName retain];
		self->_currentString = [[NSMutableString alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[self->_superDelegate release];
	[self->_currentString release];
	[self->_elementName release];

	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
{
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
{
		
	[self->_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
// The parser reports ignorable whitespace in the same way as characters it's found.
{
	
	[self->_currentString appendString:whitespaceString];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
// ...and this reports a fatal error to the delegate. The parser will stop parsing.
{
}

@end


@implementation GWXMLDeserializerParserLongLongDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		long long value = [self->_currentString longLongValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedLongLongValue:)])
		{
			[self->_superDelegate setDeserializedLongLongValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

@end


@implementation GWXMLDeserializerParserShortDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		short value = (short)[self->_currentString intValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedShortValue:)])
		{
			[self->_superDelegate setDeserializedShortValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

@end

@implementation GWXMLDeserializerParserIntDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		int value = (short)[self->_currentString intValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedIntValue:)])
		{
			[self->_superDelegate setDeserializedIntValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

@end

@implementation GWXMLDeserializerParserBoolDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		bool value = (bool)[self->_currentString boolValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedBoolValue:)])
		{
			[self->_superDelegate setDeserializedBoolValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}


@end


@implementation GWXMLDeserializerParserLongDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		long value = (long)[self->_currentString longLongValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedLongValue:)])
		{
			[self->_superDelegate setDeserializedLongValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}


@end


@implementation GWXMLDeserializerParserDoubleDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		double value = (double)[self->_currentString doubleValue];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedDoubleValue:)])
		{
			[self->_superDelegate setDeserializedDoubleValue:value];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

@end

@implementation GWXMLDeserializerParserObjectDelegate

+ (NSDictionary *)copyPropertyListOfClass:(Class)class
{
	if(!class)
	{
		return nil;
	}
	
	// empty header node.
	propertyListNode_t header = malloc(sizeof(struct propertyListNode));
	header->count = 0;
	header->next = NULL;
	header->list = NULL;
	unsigned int totalCount = 0;
	
	while(class)
	{
		propertyListNode_t node = malloc(sizeof(struct propertyListNode));
		node->list = class_copyPropertyList(class, &node->count);
		
		if(node->list)
		{
			node->next = header->next;
			header->next = node;
			totalCount += node->count;
		}
		else
		{
			free(node);
		}
		
		class = class_getSuperclass(class);
	}
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:totalCount];
	
	if(totalCount > 0)
	{
		while(header)
		{			
			for(int i = 0; i < header->count; i++)
			{
				const char* property_name = property_getName(*(header->list + i));
				const char* property_attributes = property_getAttributes(*(header->list + i));
				NSString *name = [NSString stringWithUTF8String:property_name];
				NSString *attributes = [NSString stringWithUTF8String:property_attributes];
				
				[dictionary setObject:attributes forKey:name];	
			}
			
			propertyListNode_t temp = header;
			header = header->next;
			free(temp->list);
			free(temp);
		}
	}
    
    if (header) {
        free(header);
    }
	
	return dictionary;
}

- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName
{
	Class class = nil;
	if((class = [GWXMLDeserializerParserDelegate classFromName:elementName]))
	{
		self = [self initWithSupperDelegate:superDelegate elementName:elementName class:class];
	}
	else
	{
		[self release];
		self = nil;
	}
	
	return self;
}

- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName class:(Class)class
{
	if(self = [super initWithSupperDelegate:superDelegate elementName:elementName])
	{
		self->_class = [class retain];
		self->_properties = [GWXMLDeserializerParserObjectDelegate copyPropertyListOfClass:class];
		self->_i_result = [[class alloc] init];
	}
	
	return self;
}

-(void)dealloc
{
	[self->_class release];
	[self->_properties release];
	[self->_i_result release];
	[super dealloc];
}

// todo: add the suport for the other data types.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
{
	// encounters the element in the type.
	NSString *propertyAttributes = [self->_properties objectForKey:elementName];
	if(propertyAttributes)
	{
		// get current setter and selector.
		NSString *capitalizedPropertyName = elementName;
		unichar firstChar = [capitalizedPropertyName characterAtIndex:0];
		if(firstChar >= 'a' && firstChar <= 'z')
		{
			firstChar += 'A' - 'a';
			capitalizedPropertyName = [[NSString stringWithCharacters:&firstChar length:1] 
									   stringByAppendingString:[capitalizedPropertyName substringFromIndex:1]];
		}				
		
		self->_currentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalizedPropertyName]);
		self->_currentSetter = [self->_i_result methodForSelector:self->_currentSelector];		
		
		// will handle this element.
		unichar type = [propertyAttributes characterAtIndex:1];
		// 1. the type of the element are not objc class type.
		/*
		 c A char
		 i An int
		 s A short
		 l A long
		 q A long long
		 C An unsigned char
		 I An unsigned int
		 S An unsigned short
		 L An unsigned long
		 Q An unsigned long long
		 f A float
		 d A double
		 B A C++ bool or a C99 _Bool
		 v A void
		 * A character string (char *)
		 @ An object (whether statically typed or typed id)
		 # A class object (Class)
		 : A method selector (SEL)
		 */
				
		switch (type) {
			
			case 'q':
			{
				GWXMLDeserializerParserLongLongDelegate *longlongDelegate = 
					[[[GWXMLDeserializerParserLongLongDelegate alloc] initWithSupperDelegate:self 
																			   elementName:elementName] autorelease];
				parser.delegate = longlongDelegate;
				break;
			}
			case 's':
			{
				GWXMLDeserializerParserShortDelegate *shortDelegate =
				[[[GWXMLDeserializerParserShortDelegate alloc] initWithSupperDelegate:self 
																		 elementName:elementName] autorelease];
				parser.delegate = shortDelegate;
				break;
			}
			case 'B':
			{
				GWXMLDeserializerParserBoolDelegate *boolDelegate =
				[[[GWXMLDeserializerParserBoolDelegate alloc] initWithSupperDelegate:self 
																		  elementName:elementName] autorelease];
				parser.delegate = boolDelegate;
				break;
			}	
            case 'i':
            {
                GWXMLDeserializerParserIntDelegate *intDelegate = 
                [[[GWXMLDeserializerParserIntDelegate alloc] initWithSupperDelegate:self 
                                                                       elementName:elementName] autorelease];
                
                parser.delegate = intDelegate;
                break;
            }
			case 'l':
			{
				GWXMLDeserializerParserLongDelegate* longDelegate = 
				[[[GWXMLDeserializerParserLongDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
				parser.delegate = longDelegate;
				break;
			}
				
            case 'd':
            {
                GWXMLDeserializerParserDoubleDelegate *doubleDelegate = 
                [[[GWXMLDeserializerParserDoubleDelegate alloc] initWithSupperDelegate:self 
                                                                           elementName:elementName] autorelease];
                parser.delegate = doubleDelegate;
                break;
            }
			case '@':
			{
				// check the data type in the attribute xsi:type
				// TODO: refactor to reuse the following code.
				NSString *dataType = [attributeDict objectForKey:TypeAttrivuteName];
				if(!dataType)
				{
					// get the data type from the property attribute
					NSArray *components = [propertyAttributes componentsSeparatedByString:@"\""];
					if([components count] >= 3)
					{
						dataType = [components objectAtIndex:1];
					}
				}				
				// sepcial cases for NSArray and NSDate
				if([dataType isEqualToString:@"NSArray"])
				{
					GWXMLDeserializerParserNSArrayDelegate *arrayDelegate = 
					[[[GWXMLDeserializerParserNSArrayDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
					
					parser.delegate = arrayDelegate;
				}
				else if([dataType isEqualToString:@"NSDate"])
				{
					GWXMLDeserializerParserNSDateDelegate *dateDelegate =
					[[[GWXMLDeserializerParserNSDateDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
					
					parser.delegate = dateDelegate;
				}
				else if([dataType isEqualToString:@"NSString"] || [dataType isEqualToString:@"string"])
				{
					GWXMLDeserializerParserNSStringDelegate *stringDelegate = 
					[[[GWXMLDeserializerParserNSStringDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
					
					parser.delegate = stringDelegate;
				}
				else
				{
					Class class = [GWXMLDeserializerParserDelegate classFromName:dataType];
					if(class)
					{
						GWXMLDeserializerParserObjectDelegate *objectDelegate =
						[[[GWXMLDeserializerParserObjectDelegate alloc] initWithSupperDelegate:self elementName:elementName class:class] autorelease];
						
						parser.delegate = objectDelegate;
					}
				}	
				break;
			}
			default:
				break;
		}
		
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedObjectValue:)])
		{
			[self->_superDelegate setDeserializedObjectValue:self->_i_result];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

- (void)setDeserializedLongLongValue:(long long)value
{
	longlongSetter_t setter = (longlongSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedLongValue:(long)value
{
	longSetter_t setter = (longSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedObjectValue:(id)value
{
	objectSetter_t setter = (objectSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedShortValue:(short)value
{
	shortSetter_t setter = (shortSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedIntValue:(int)value
{
    intSetter_t setter = (intSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedBoolValue:(BOOL)value
{
	boolSetter_t setter = (boolSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

- (void)setDeserializedDoubleValue:(double)value
{
    doubleSetter_t setter = (doubleSetter_t)(self->_currentSetter);
	setter(self->_i_result, self->_currentSelector, value);
}

@end

static NSDateFormatter *ISO8601Formatter;

@implementation GWXMLDeserializerParserNSStringDelegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedObjectValue:)])
		{
			[self->_superDelegate setDeserializedObjectValue:self->_currentString];
		}
		
		parser.delegate = self->_superDelegate;
	}
}


@end


@implementation GWXMLDeserializerParserNSDateDelegate

+ (void)initialize
{
	ISO8601Formatter = [[[NSDateFormatter alloc] init] autorelease];
	ISO8601Formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		NSString *dateString = self->_currentString;
		// the formatter does not support iso8601 directly, need to walk around the Z case
		if([dateString hasSuffix:@"Z"])
		{
			dateString = [[dateString substringToIndex:19] stringByAppendingString:@"+0000"];
		}
		
		NSDate *date = [ISO8601Formatter dateFromString:dateString];
		
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedObjectValue:)])
		{
			[self->_superDelegate setDeserializedObjectValue:date];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

@end


@implementation GWXMLDeserializerParserNSArrayDelegate
- (id)initWithSupperDelegate:(id)superDelegate elementName:(NSString *)elementName
{
	if(self = [super initWithSupperDelegate:superDelegate elementName:elementName])
	{
		self->_array = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	// For NSArray type, all the elements of the array should be objects (ids).	
	// either the xsi:type attribute or the element name is the name of the data type.
	// check the data type in the attribute xsi:type
	NSString *dataType = [attributeDict objectForKey:TypeAttrivuteName];
	if(!dataType)
	{
		// get the data type as the element name
		dataType = elementName;
	}
	
	// sepcial cases for NSArray and NSDate
	if([dataType isEqualToString:@"NSArray"])
	{
		GWXMLDeserializerParserNSArrayDelegate *arrayDelegate = 
		[[[GWXMLDeserializerParserNSArrayDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
		
		parser.delegate = arrayDelegate;
	}
	else if([dataType isEqualToString:@"NSDate"])
	{
		GWXMLDeserializerParserNSDateDelegate *dateDelegate =
		[[[GWXMLDeserializerParserNSDateDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
		
		parser.delegate = dateDelegate;
	}
	else if([dataType isEqualToString:@"NSString"] || [dataType isEqualToString:@"string"])
	{
		GWXMLDeserializerParserNSStringDelegate *stringDelegate = 
		[[[GWXMLDeserializerParserNSStringDelegate alloc] initWithSupperDelegate:self elementName:elementName] autorelease];
		
		parser.delegate = stringDelegate;
	}
	else
	{
		Class class = [GWXMLDeserializerParserDelegate classFromName:dataType];
		if(class)
		{
			GWXMLDeserializerParserObjectDelegate *objectDelegate =
			[[[GWXMLDeserializerParserObjectDelegate alloc] initWithSupperDelegate:self elementName:elementName class:class] autorelease];
			
			parser.delegate = objectDelegate;
		}
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
	if([elementName isEqualToString:self->_elementName])
	{
		if([self->_superDelegate respondsToSelector:@selector(setDeserializedObjectValue:)])
		{
			[self->_superDelegate setDeserializedObjectValue:self->_array];
		}
		
		parser.delegate = self->_superDelegate;
	}
}

- (void)setDeserializedObjectValue:(id)value
{
	[self->_array addObject:value];
}

- (void)dealloc
{
	[self->_array release];
	[super dealloc];
}

@end



