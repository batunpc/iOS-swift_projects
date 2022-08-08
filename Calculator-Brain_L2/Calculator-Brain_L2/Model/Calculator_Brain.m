//
//  Calculator_Brain.m
//  Calculator
//
//  Created by Batuhan Ipci on 2022-06-01.
//

#import "Calculator_Brain.h"

@interface Calculator_Brain()//private method and props
@property (nonatomic, strong) NSMutableArray *items;
-(double)popItem;
@end

@implementation Calculator_Brain

-(NSMutableArray*)items{//lazy loading
    if (_items == nil)
        _items = [[NSMutableArray alloc]init];
    return _items;
}

-(void)pushItem:(double)number{
    [self.items addObject:[NSNumber numberWithDouble:number]];
}

-(double)popItem{
    NSNumber *lastObj=[self.items lastObject];
    if (lastObj)[self.items removeLastObject];
    return [lastObj doubleValue];
}

-(double)calculate{
    double result = 0;
    if (!self.operation) return result;
    
    double lvalue = [self popItem];
    double fvalue = [self popItem];
    NSLog(@"%f %@ %f", fvalue, self.operation, lvalue);

    if ([self.operation isEqualToString:@"+"]) result = fvalue + lvalue ;
    else if([self.operation isEqualToString:@"x"]) result = fvalue * lvalue;
    else if([self.operation isEqualToString:@"-"]) result = fvalue - lvalue;
    else if([self.operation isEqualToString:@"÷"]) result = fvalue / lvalue;
    self.operation = nil; //set the operation pointer weak to NSString
    [self pushItem:result];

    return result;
    
}


@end
