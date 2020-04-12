//
//  TestModel.h
//  Test
//
//  Created by 刘广 on 2020/4/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long creationTime;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int type;

@end

NS_ASSUME_NONNULL_END
