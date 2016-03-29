//
//  Util.m
//  YATimer
//
//  Created by ihandysoft on 16/3/29.
//  Copyright © 2016年 ihandysoft. All rights reserved.
//

#import "Util.h"

@implementation Util


+ (void)callBackFun:(int) argsCount Argus:(id) firstObj,...{
    
    if (argsCount > 2) {
        return;
    }
    va_list args;
    va_start(args, firstObj);
    
    SEL selector = va_arg(args, SEL);
    
    id arg1 = NULL;
    id arg2 = NULL;
    
    for (int i =0;i < argsCount; i++)
    {
        if (i == 0) {
            arg1 = va_arg(args, id);
        }
        else{
            arg2 = va_arg(args, id);
        }
        
    }
    
    
    if ([firstObj respondsToSelector:selector]) {
        if (argsCount == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [firstObj performSelector:selector];
#pragma clang diagnostic pop
            
        }
        else if (argsCount == 1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [firstObj performSelector:selector withObject:arg1];
#pragma clang diagnostic pop
            
        }
        else if (argsCount == 2) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [firstObj performSelector:selector withObject:arg1 withObject:arg2];
#pragma clang diagnostic pop
            
        }
    }
    
    va_end(args);
}



@end
