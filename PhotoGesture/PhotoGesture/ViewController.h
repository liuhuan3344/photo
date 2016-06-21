//
//  ViewController.h
//  PhotoGesture
//
//  Created by LH on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong,nonatomic)UIScrollView *svMain;           //背景滚动式图
@property (strong,nonatomic)UIView *viewBg;                 //上面的文本背景
@property (strong,nonatomic)UIView *viewlin;                 //上面的线
@property (strong,nonatomic)UITextField *tfView;             //文本输入
@property (strong,nonatomic)NSMutableArray *phonelist;      //图片数组
@property (strong,nonatomic)UIView *tagviewBg;              //标签背景
@property (strong,nonatomic)UIButton *btndel;               //删除画板按钮
@property (strong,nonatomic)UIButton *btnAddPhone;          //添加照片按钮
@end

