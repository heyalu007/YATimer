

#import <Foundation/Foundation.h>

@interface YATimer : NSObject
+ (YATimer*)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat;
+ (YATimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat actions:(void(^)(void))actions;
- (void)fire;
- (NSTimer *) timer;
@end
