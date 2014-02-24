//
//  IBParser.m
//  IBFrameFind
//
//  Created by Mark Bellott on 12/19/13.
//  Copyright (c) 2013 MarkBellott. All rights reserved.
//

#import "IBParser.h"


@implementation IBParser{
    BOOL _beginParsingSubviews;
    NSString *_objectName;
    NSString *_finalPrintFrame;
    NSArray *_supportedViewTypes;
    
    NSMutableArray *printArray;
}

#pragma mark - Init and Load Method

- (id)init{
    self = [super init];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup{
    _beginParsingSubviews = NO;
    _objectName = @"";
    _finalPrintFrame = @"";
    printArray = [[NSMutableArray alloc] init];
    [self loadSupportedViewTypes];
}

- (void)loadSupportedViewTypes{
    _supportedViewTypes = @[@"activityIndicatorView",
                            @"adBannerView",
                            @"button",
                            @"collectionView",
                            @"datePicker",
                            @"glkView",
                            @"imageView",
                            @"label",
                            @"mapView",
                            @"navigationBar",
                            @"pageControl",
                            @"pickerView",
                            @"progressView",
                            @"scrollView",
                            @"segmentedControl",
                            @"slider",
                            @"stepper",
                            @"switch",
                            @"tableView",
                            @"textField",
                            @"textView",
                            @"view",
                            @"webView"];
}

#pragma mark - XML Methods

- (void)parserFiles:(NSArray*)files{
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for(NSInteger i=0; i < [files count]; i++){
        
        printArray = [[NSMutableArray alloc] init];
        
        NSString *fileName = files[i];
        
        printf("\n--- %s ---\n\n",[fileName cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        
        NSString *path = [[fileManager currentDirectoryPath] stringByAppendingString:@"/"];
        path = [path stringByAppendingString:fileName];
        
        
        NSInputStream *inStream = [[NSInputStream alloc] initWithFileAtPath:path];
        inStream.delegate = self;
        [inStream open];
        
        if(!inStream.hasBytesAvailable){
            printf("%s does not exist in your current directory.\n",
                   [fileName cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        }
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithStream:inStream];
        xmlParser.delegate = self;
        [xmlParser parse];
        
        [self printSortedFrameData];
        
        _beginParsingSubviews = NO;
    }
    
    printf("\n");
}

#pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"subviews"]){
        _beginParsingSubviews = YES;
    }
    
    if(_beginParsingSubviews){
        if([_supportedViewTypes containsObject:elementName]){
            if([attributeDict objectForKey:@"userLabel"]){
                _objectName = [attributeDict objectForKey:@"userLabel"];
            }
            else{
                _objectName = [NSString stringWithFormat:@"(NO_NAME)%@",elementName];
            }
        }
        else if([elementName isEqualToString:@"rect"]){

            NSString *frameData =
            [NSString stringWithFormat:@".frame = CGRectMake(%@, %@, %@, %@);",
             [attributeDict objectForKey:@"x"],
             [attributeDict objectForKey:@"y"],
             [attributeDict objectForKey:@"width"],
             [attributeDict objectForKey:@"height"]];
            
            _finalPrintFrame = [_objectName stringByAppendingString:frameData];

            [printArray addObject:_finalPrintFrame];
        }
    }
}

- (void)printSortedFrameData{
    NSArray *sortedArray = [printArray sortedArrayUsingComparator:^(id obj1, id obj2){
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        
        return [s1 compare:s2];
    }];
    
    for(NSString *s in sortedArray){
        printf("%s\n",[s cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}



@end
