

#import <Foundation/Foundation.h>

@interface YATimerBridge : NSObject

+ (YATimerBridge *)timerBridgeWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat;

+ (YATimerBridge *)timerBridgeWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat actions:(void(^)(void))actions;

- (void)fire;
- (void)invalidate;

- (BOOL)isValid;
- (NSTimer *)bridgeTimer;
@end
