//
//  main.m
//  chatServer
//
//  Created by Kang on 2015. 10. 6..
//  Copyright © 2015년 Kang. All rights reserved.
//

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import <errno.h>


#import <Foundation/Foundation.h>

NSString* serverName = @"server";
const char* buf;
char reciever[2048];




void toInitData(NSArray* initData, int server_sockfd)
{
    for(int i = 0; i < [initData count]; i++)
    {
        
        buf = [[[initData objectAtIndex:i] objectAtIndex:0] UTF8String];
        send(server_sockfd, buf, 2048, 0);
        read(server_sockfd, reciever, 2048);
        
        buf = [[[initData objectAtIndex:i] objectAtIndex:1] UTF8String];
        send(server_sockfd, buf, 2048, 0);
        read(server_sockfd, reciever, 2048);
        
        buf = [[[initData objectAtIndex:i] objectAtIndex:2] UTF8String];
        send(server_sockfd, buf, 2048, 0);
        read(server_sockfd, reciever, 2048);
    }
    
    buf = "admin";
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
    
    buf = "exit";
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
    
    buf = "hh-mm-ss";
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
}




void toLineData(NSArray* conChat, int server_sockfd)
{
    
    buf = [[conChat objectAtIndex:0] UTF8String];
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
    
    buf = [[conChat objectAtIndex:0] UTF8String];
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
    
    
    buf = [[conChat objectAtIndex:0] UTF8String];
    send(server_sockfd, buf, 2048, 0);
    read(server_sockfd, reciever, 2048);
}


void initDataMake(NSMutableArray* initData)
{
    for(int i = 0; i < 12 ; i++)
    {
        NSString* name;
        if(i%2 == 0)
        {
            name = @"kjh";
        }else
        {
             name=@"server";
        }
        
        NSString* content = @"content";
        NSString* combine = [NSString stringWithFormat:@"%@ %d", content, i];

        
        NSArray* chatCon = [[NSArray alloc]initWithObjects:name, combine, @"hh-mm-ss", nil];
        
        [initData addObject:chatCon];
    }
    NSLog(@"dummy data maked");

}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        int server_sockfd, client_sockfd;
        unsigned int client_len;
        struct sockaddr_in clientaddr, serveraddr;

        
        NSMutableArray* initData = [[NSMutableArray alloc]init];
        
        initDataMake(initData);
        
        
        server_sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        
        bzero(&serveraddr, sizeof(serveraddr));
        serveraddr.sin_family = AF_INET;
        serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
        serveraddr.sin_port = htons(8000);
        
        
        if((bind(server_sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr))) == -1)
        {
            printf("error : %d \n", errno);
            return -1;
        }else
        {
            printf("bind complete....\n");
        };
        
        if((listen(server_sockfd, 5)) == 0)
        {
            printf("Listening...\n");
        }else{
            printf("Listen fail\n");
        };
        
        printf("\n");
        printf("wait.... \n");
        printf("\n");

        memset(reciever, 0x00, 2048);
  
        client_sockfd = accept(server_sockfd, (struct sockaddr*) &clientaddr, &client_len);
        
        read(client_sockfd, reciever, 2048);
        printf("%s entered!!\n", reciever);
        printf("\n");


        toInitData(initData, client_sockfd);  // 초기 데이터 전달 완료
        
        
        memset(reciever, 0x00, 2048);
        
        while(1)
        {
            printf("loop..\n");
            
            (client_sockfd, reciever, 2048);
            NSString* name = [NSString stringWithUTF8String:reciever];
            
            send(client_sockfd, reciever, 2048,0);
//            NSLog(@"name : %@", name);
            
            read(client_sockfd, reciever, 2048);
            NSString* text = [NSString stringWithUTF8String:reciever];
            send(client_sockfd, reciever, 2048,0);
//            NSLog(@"text : %@", text);
            
            
            read(client_sockfd, reciever, 2048);
            NSString* time = [NSString stringWithUTF8String:reciever];
            send(client_sockfd, reciever, 2048,0);
//            NSLog(@"time : %@", time);
            
            NSLog(@"chat line added : %@, %@, %@", name, text, time);
            if([name isEqualToString:@"admin"] && [text isEqualToString:@"exit"])
            {
                break;
            }
            
            NSArray* chatCon = [[NSArray alloc]initWithObjects:name, text, time, nil];
            [initData addObject:chatCon];
            
        }
        
        NSLog(@"connection over");
        NSLog(@"%@", initData);
        
        close(client_sockfd);
        close(server_sockfd);
        
    }
    return 0;
}


//        //1 소켓을 연다.(리슨)
//
//        int result;
//
//        //1-1 make socket
//        CFSocketRef ref = CFSocketCreate(
//                                         kCFAllocatorDefault,
//                                         PF_INET,
//                                         SOCK_STREAM,
//                                         IPPROTO_TCP,
//                                         kCFSocketAcceptCallBack|kCFSocketReadCallBack|kCFSocketWriteCallBack,
//                                         0,
//                                         NULL);
//
//
//
//        if(CFSocketIsValid(ref))
//        {
//            NSLog(@"true");
//        }
//
//
//
//        //1-2 bind
//        struct sockaddr_in sin;
//
//        memset(&sin, 0, sizeof(sin));
//        sin.sin_len = sizeof(sin);
//        sin.sin_family = AF_INET;
//        sin.sin_port = htons(2500);  //port
//        sin.sin_addr.s_addr = INADDR_ANY;
//
//        CFDataRef sincfd = CFDataCreate(kCFAllocatorDefault,
//                                        (UInt8*) &sin,
//                                        sizeof(sin));
//
//        CFSocketSetAddress(ref,sincfd);
//
//        CFRelease(sincfd);
//
//
//
//        //1-3 listen
//        CFRunLoopSourceRef socketsource = CFSocketCreateRunLoopSource(
//                                                                      kCFAllocatorDefault,
//                                                                      ref,
//                                                                      0);
//
//        CFRunLoopAddSource(
//                           CFRunLoopGetCurrent(),
//                           socketsource,
//                           kCFRunLoopDefaultMode);
//
//        NSLog(@"%@",ref);
//
//        //2 array를 생성한다.
//
//        chatRoom = [[NSMutableArray alloc]init];
//
//
//        //3 옵저버 생성해서 소켓을 관리한다.
//
//
//
//
//
//   // 4 소켓을 닫는다.
//    CFSocketInvalidate(ref);
