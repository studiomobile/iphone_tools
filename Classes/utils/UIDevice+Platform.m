//
//  UIDevice+Platform.m
//  iPhoneTools
//
//  Created by Sergey Martynov on 08.09.11.
//  Copyright (c) 2011 Studio Mobile. All rights reserved.
//

#import "UIDevice+Platform.h"

@implementation UIDevice (Platform)

+ (NSInteger)systemMajorVersion
{
    return [[UIDevice currentDevice].systemVersion integerValue];
}

@end
