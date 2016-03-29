

#import "YATimerBridge.h"
#import "Util.h"

@interface YATimerBridge ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL targetSelector;
@property (nonatomic, copy) void (^targetBlock)(void);
@property (nonatomic, assign) BOOL repeat;

@end

#define PP_NARG(...) PP_NARG_(__VA_ARGS__,PP_RSEQ_N()) /* 求参数个数 */
#define PP_NARG_(...) PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N( \
__1,__2,__3,__4,__5,__6,__7,__8,__9,_10,\
_11,_12,_13,_14,_15,_16,_17,_18,_19,_20,\
_21,_22,_23,_24,_25,_26,_27,_28,_29,_30,\
_31,_32,_33,_34,_35,_36,_37,_38,_39,_40,\
_41,_42,_43,_44,_45,_46,_47,_48,_49,_50,\
_51,_52,_53,_54,_55,_56,_57,_58,_59,_60,\
_61,_62,_63,N,...) N
#define PP_RSEQ_N() \
63,62,61,60,\
59,58,57,56,55,54,53,52,51,50,\
49,48,47,46,45,44,43,42,41,40,\
39,38,37,36,35,34,33,32,31,30,\
29,28,27,26,25,24,23,22,21,20,\
19,18,17,16,15,14,13,12,11,10,\
9,8,7,6,5,4,3,2,1,0

#define callBack(...) \
int i = PP_NARG(__VA_ARGS__);\
[Util callBackFun:i-2 Argus:__VA_ARGS__];


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
