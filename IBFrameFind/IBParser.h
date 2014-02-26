//
//  IBParser.h
//  IBFrameFind
//
//  Created by Mark Bellott on 12/19/13.
//  Copyright (c) 2013 MarkBellott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBParser : NSObject
<NSStreamDelegate,
NSXMLParserDelegate>

- (void)parseFiles:(NSArray *)files;

@end
