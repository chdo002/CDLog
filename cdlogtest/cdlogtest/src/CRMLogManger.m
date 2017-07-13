//
//  CRMLogManger.m
//  PaicAATService
//
//  Created by 李苏阳(外包) on 2017/6/20.
//  Copyright © 2017年 chdo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CRMLogManger.h"
#define fileManger  [NSFileManager defaultManager]
@interface CRMLogManger()

{
    NSMutableDictionary *logDic;
    
}

@property (nonatomic, strong, readwrite) dispatch_queue_t saveQueue;

//@property (nonatomic, copy) NSMutableDictionary *logDic;
@end

@implementation CRMLogManger

+(CRMLogManger *)share {
    static CRMLogManger * shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[CRMLogManger alloc] init];
        [shareInstance setUp];
    });
    
    return shareInstance;
}

-(void)setUp {
    
    self.saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_SERIAL);
    logDic = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLogToLocal) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLogToLocal) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLogToLocal) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLogToLocal) name:@"CRMSTARTSAVELOGNOTIFICATION" object:nil];
}

-(void)inputLog: (NSString *)content {
    
    dispatch_async(self.saveQueue, ^{
        
//        NSString *currentID = [[[CRMInnerService share].umId copy] uppercaseString];
        
        NSString *currentID = [@"用户的ID" uppercaseString];
        
        NSDate *date = [NSDate date];
        NSDateFormatter * formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"YYYY-MM-dd  HH:mm:ss "];
        NSString *timeStr = [formate stringFromDate:date];
        
        NSString *oldContent = [logDic objectForKey:currentID];
        NSString *newLogStr = oldContent ? oldContent : @"日志开始\n";
        newLogStr = [NSString stringWithFormat:@"%@\n%@----%@", newLogStr, timeStr, content];
        if (currentID) {
         [logDic setValue:newLogStr forKey:currentID];
        }
    });
}

-(void)saveLogToLocal {
    
    [logDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull umid, id  _Nonnull logStr, BOOL * _Nonnull stop) {
        [self fetchFileHandler:umid content:logStr];
    }];
    
    logDic = [NSMutableDictionary dictionary];
}

-(void)fetchFileHandler: (NSString *)umident  content: (NSString *)contStr {
//    if (!handler) {
    
//    NSFileHandle *handler;
    
        NSString *folderPath = [self userfolderPath:umident];
        NSString *filePath = [folderPath stringByAppendingPathComponent:@"log.txt"];
        BOOL isDirectory, isExist;
        isExist = [fileManger fileExistsAtPath:folderPath isDirectory:&isDirectory]; // /xxx/xxx/Documents/Users/xxxx/
        
        // 文件夹不存在
        if (!isExist || (isExist && !isDirectory)) { //
            // 新的日志文件夹
//            NSError *error = nil;
            
            [fileManger createDirectoryAtPath:folderPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:nil];
//            // 新的日志文件
//            [fileManger createFileAtPath:filePath contents:nil attributes:nil];
//            handler = [NSFileHandle fileHandleForWritingAtPath:filePath];
            
            [contStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
        } else {
            
            // 文件不存在
            if (![fileManger fileExistsAtPath:filePath]) {
//                [fileManger createFileAtPath:filePath contents:nil attributes:nil];
                [contStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            } else {
                NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:filePath];
                [handler seekToEndOfFile];
                NSData *data = [contStr dataUsingEncoding:NSUTF8StringEncoding];
                [handler writeData:data];
                [handler closeFile];
            }
//            handler = [NSFileHandle fileHandleForWritingAtPath:filePath];
        }
    
//    return handler;
}


// 用户文件夹路径
-(NSString *)userfolderPath: (NSString *)userID {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"Users"];
    
    
//    long env = [[CRMUserDefaults objectForKey:k_CRMEnvironment] integerValue];
    
    NSString *folderName = userID;
    
//    if (env != 1) { // 不是测试环境, 则用户ID加密
//        folderName = [self slm_md5:userID];
//    }
    
    NSString *folderPath = [path stringByAppendingPathComponent:folderName]; // 用户目录  /xxxxx/Documents/Users/xxxxx
    
    return folderPath;
}

//
//- (NSString *)slm_md5: (NSString* )ori
//{
//    if (!ori || ori.length <= 0) {
//        return nil;
//    }
//
//    const char *value = [ori UTF8String];
//    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
//
//    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
//        [outputString appendFormat:@"%02x",outputBuffer[count]];
//    }
//
//#if __has_feature(objc_arc)
//    return outputString;
//#else
//    return [outputString autorelease];
//#endif
//}

@end
