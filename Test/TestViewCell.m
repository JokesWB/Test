//
//  TestViewCell.m
//  Test
//
//  Created by 刘广 on 2020/4/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import "TestViewCell.h"

@interface TestViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation TestViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TestModel *)model
{
    _model = model;
    self.titleLabel.text = model.content;
    self.timeLabel.text = [self getTimeFromTimestamp];
}


- (NSString *)getTimeFromTimestamp{

    NSDate *myDate=[NSDate dateWithTimeIntervalSince1970:self.model.creationTime / 1000];

    //设置时间格式

    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    //将时间转换为字符串

    NSString *timeStr=[formatter stringFromDate:myDate];

    return timeStr;

}


@end
