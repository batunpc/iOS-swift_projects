//
//  ViewController.m
//  Calculator-Brain_L2
//
//  Created by Batuhan Ipci on 2022-06-04.
//

#import "ViewController.h"
#import "Calculator_Brain.h"


@interface ViewController ()
@property (nonatomic) BOOL enterNum;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic, strong)Calculator_Brain *calcBrain;
@end

@implementation ViewController

-(Calculator_Brain*)calcBrain{
    if (_calcBrain == nil) _calcBrain = [[Calculator_Brain alloc]init];
    return _calcBrain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.titleLabel.text;

    if (self.enterNum) {
        if ([self.display.text isEqualToString:@"0"]) self.display.text = @""; //placeholder
        digit = [NSString stringWithFormat:@"%@%@",self.display.text,digit]; //append
    }else{
        if ([digit isEqualToString:@"."]) digit = @"0.";
        self.enterNum = YES;
    }
    self.display.text = digit;
}
    
- (IBAction)enterPressed {
    self.enterNum = NO;
    NSString *valueEntered = self.display.text;
    [self.calcBrain pushItem:valueEntered.doubleValue];
    
    if (self.calcBrain.operation) {
        [self calculate];
    }
}

- (IBAction)oprPressed:(UIButton *)sender {
    if (self.enterNum) [self enterPressed];
    self.calcBrain.operation = sender.titleLabel.text;
    NSLog(@"%@", self.calcBrain.operation);
}

-(void)calculate{ //calls the calculate operation from calBrain
    double result = [self.calcBrain calculate];
    self.display.text = [NSString stringWithFormat:@"%g" , result]; // 0s
}

@end
