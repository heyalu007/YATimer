

#import "ViewController.h"
#import "YATimer.h"

@interface ViewController ()

@property (nonatomic, strong) YATimer *timer1;
//@property (nonatomic, strong) YATimer *timer2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer1 = [YATimer timerWithTimeInterval:1.0 target:self selector:@selector(test:) withObject:@"时间到了" repeats:YES];
    // 这个timer不会让self的retainCount加1；
}

- (void)test:(NSString *)info {

    NSLog(@"%@",info);
}

@end
