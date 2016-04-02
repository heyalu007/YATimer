

#import "YATimerBridge.h"
#import "Util.h"

@interface YATimerBridge ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL targetSelector;
@property (nonatomic, copy) void (^targetBlock)(void);
@property (nonatomic, assign) BOOL repeat;

@end


@implementation YATimerBridge

- (instancetype)init {
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

- (void)fire {
    [self.timer fire];
}


- (NSTimer *)bridgeTimer {
    return self.timer;
}

- (void)fire:(id)object {
    NSTimer *tempTimer = (NSTimer *)object;
    
    if (self.target != nil && self.targetSelector != NULL) {
        if ([self.target respondsToSelector:self.targetSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.targetSelector withObject:tempTimer.userInfo];
#pragma clang diagnostic pop
        }
    }
    else if (self.targetBlock != nil) {
        self.targetBlock();
    }
    
    if (!self.repeat) {
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
