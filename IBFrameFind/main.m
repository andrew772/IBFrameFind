//
//  main.m
//  xibFrameParse
//
//  Created by Mark Bellott on 12/19/13.
//  Copyright (c) 2013 MarkBellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBParser.h"

int main(int argc, const char * argv[]){

    @autoreleasepool{
        
        if(argc < 2){
            printf("Usage: ./IBFrameFind fileOne.xib fileTwo.xib ...\n");
        }
        
        else{
            NSInteger fileCount = argc - 1;
            NSMutableArray *files = [[NSMutableArray alloc] initWithCapacity:fileCount];
            
            for(NSInteger i = 0; i < fileCount; i++){
                files[i] = [NSString stringWithUTF8String:argv[i + 1]];
            }
    
            IBParser *parser = [[IBParser alloc] init];
            [parser parseFiles:files];
        }
        
    }
    
    return 0;
}

