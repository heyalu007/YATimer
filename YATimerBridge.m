

#import "YATimerBridge.h"

@interface YATimerBridge ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL targetSelector;
@property (nonatomic, copy) void (^targetBlock)(void);
@property (nonatomic, assign) BOOL repeat;

@end

@implementation YATimerBridge
@synthesize target;
@synthesize targetSelector;
@synthesize targetBlock;
@synthesize repeat;
- (id)init {
    self = [super init];
    return self;
}

+ (YATimerBridge *)timerBridgeWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat {
    YATimerBridge *controller = [[YATimerBridge alloc] init];
    controller.target = target;
    controller.targetSelector = selector;
    controller.repeat = repeat;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:controller selector:@selector(fire:) userInfo:object repeats:repeat];
    
    controller.timer = timer;
    
    return controller;
}

+ (YATimerBridge *)timerBridgeWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat actions:(void(^)(void))actions {
    YATimerBridge *controller = [[YATimerBridge alloc] init];
    controller.targetBlock = actions;
    controller.repeat = repeat;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:controller selector:@selector(fire:) userInfo:nil repeats:repeat];
    
    controller.timer = timer;
    
    return controller;
}

- (void)fire{
    [self.timer fire];
}


- (NSTimer *)bridgeTimer{
    return self.timer;
}

- (void)fire:(id)object {
    NSTimer * tempTimer = (NSTimer *)object;
    
    if (target != nil && targetSelector != NULL) {
        callBack(target, targetSelector,tempTimer.userInfo);
    } else if (targetBlock != nil) {
        targetBlock();
    }
    
    if (!repeat) {
        [self invalidate];
    }
}

- (void)invalidate {
    self.target = nil;
    self.targetBlock = nil;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isValid {
    return [self.timer isValid];
}

- (void)dealloc {
    [self.timer invalidate];
}
@end
