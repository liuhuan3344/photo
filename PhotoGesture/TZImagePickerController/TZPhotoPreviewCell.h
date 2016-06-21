//
//  TZPhotoPreviewCell.h
//  TZImagePickerController
//
//  Created by LH AND GYZ on 15/12/24.
//  Copyright © 2015年 江苏时光科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZAssetModel;
@interface TZPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) TZAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();

@end
