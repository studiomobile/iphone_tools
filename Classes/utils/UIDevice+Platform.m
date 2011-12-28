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
    static int systemMajorVersion = 0;
    if (!systemMajorVersion) {
        systemMajorVersion = [[UIDevice currentDevice].systemVersion integerValue];
    }

    return systemMajorVersion;
}

@end
