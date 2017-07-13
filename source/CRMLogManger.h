//
//  CRMLogManger.h
//  PaicAATService
//
//  Created by 李苏阳(外包) on 2017/6/20.
//  Copyright © 2017年 chdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMLogManger : NSObject
+(CRMLogManger *)share;
-(void)inputLog: (NSString *)content;
@end
