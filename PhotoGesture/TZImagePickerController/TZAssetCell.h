//
//  TZAssetCell.h
//  TZImagePickerController
//
//  Created by LH AND GYZ on 15/12/24.
//  Copyright © 2015年 江苏时光科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZAssetCellTypePhoto = 0,
    TZAssetCellTypeLivePhoto,
    TZAssetCellTypeVideo,
    TZAssetCellTypeAudio,
} TZAssetCellType;

@class TZAssetModel;
@interface TZAssetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (nonatomic, strong) TZAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) TZAssetCellType type;

@end


@class TZAlbumModel;

@interface TZAlbumCell : UITableViewCell

@property (nonatomic, strong) TZAlbumModel *model;

@end
