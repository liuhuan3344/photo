//
//  QTRejectViewCell.m
//  qingtime
//
//  Created by LH AND GYZ on 16/5/5.
//  Copyright © 2016年 江苏时光科技有限公司. All rights reserved.
//

#import "QTRejectViewCell.h"

@implementation QTRejectViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-40)/3,([UIScreen mainScreen].bounds.size.width-40)/3)];
        [self addSubview:self.imageView];
        self.imageView.userInteractionEnabled =YES;
        [self.imageView.layer setCornerRadius:4];
        [self.imageView.layer setMasksToBounds:YES];
        //删除按钮的实现
        self.delBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.delBtn.frame = CGRectMake(self.imageView.frame.size.width-21,1, 20, 20);
        [self.delBtn setImage:[UIImage imageNamed:@"icon_find_phone_del"] forState:UIControlStateNormal];
        [self.imageView addSubview:self.delBtn];
        
    }
    return self;
}
@end
