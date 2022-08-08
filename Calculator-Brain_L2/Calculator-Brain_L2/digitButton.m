//
//  digitButton.m
//  Calculator-Brain_L2
//
//  Created by Batuhan Ipci on 2022-06-04.
//

#import "digitButton.h"

@implementation digitButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    if (self.tag == 2) {
    self.layer.backgroundColor = UIColor.orangeColor.CGColor;
    }
    self.layer.borderColor = UIColor.systemGrayColor.CGColor;
    self.layer.borderWidth = 2.5f;
    
    self.layer.cornerRadius = 35;
    
    
}
@end
