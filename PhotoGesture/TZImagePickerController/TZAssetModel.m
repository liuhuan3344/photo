//
//  TZAssetModel.m
//  TZImagePickerController
//
//  Created by LH AND GYZ on 15/12/24.
//  Copyright © 2015年 江苏时光科技有限公司. All rights reserved.
//

#import "TZAssetModel.h"

@implementation TZAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type{
    TZAssetModel *model = [[TZAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength {
    TZAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end



@implementation TZAlbumModel


@end