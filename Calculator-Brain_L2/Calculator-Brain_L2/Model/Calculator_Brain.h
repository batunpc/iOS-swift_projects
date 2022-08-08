//
//  Calculator_Brain.h
//  Calculator
//
//  Created by Batuhan Ipci on 2022-06-01.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator_Brain : NSObject
@property (nonatomic, weak) NSString *operation;

-(void)pushItem:(double)number;
-(double)calculate;
@end

NS_ASSUME_NONNULL_END
