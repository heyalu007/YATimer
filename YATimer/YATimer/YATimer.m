

#import "YATimer.h"
#import "YATimerBridge.h"

@interface YATimer ()
@property (nonatomic, strong) YATimerBridge *timerBridge;
@end

@implementation YATimer
@synthesize timerBridge;

- (void)dealloc
{
    [timerBridge invalidate];
}

- (NSTimer *) timer{
    return [timerBridge bridgeTimer];
}


+ (YATimer *)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat{
    YATimer *timerBridge = [[YATimer alloc] initWithTimeInterval:interval target:target selector:selector withObject:object repeats:repeat];
    return timerBridge;
}

+ (YATimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat actions:(void(^)(void))actions{
    YATimer *timerBridge = [[YATimer alloc] initWithTimeInterval:interval repeats:repeat actions:actions];
    return timerBridge;
}

- (id)initWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat{
    self = [super init];
    if (self) {
        self.timerBridge = [YATimerBridge timerBridgeWithTimeInterval:interval target:target selector:selector withObject:object repeats:repeat];
    }
    return self;
}

- (id)initWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat actions:(void(^)(void))actions{
    self = [super init];
    if (self) {
        self.timerBridge = [YATimerBridge timerBridgeWithTimeInterval:interval repeats:repeat actions:actions];
    }
    
    return self;
}

- (void)fire{
    [self.timerBridge fire];
}

@end
