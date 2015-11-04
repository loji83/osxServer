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

NSMutableArray* chatRoom;
void getChat();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
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
        
        int server_sockfd, client_sockfd;
        unsigned int client_len;
        struct sockaddr_in clientaddr, serveraddr;
        char buf[1024];
        
        NSMutableArray* chatCon = [[NSMutableArray alloc]init];
        for(int i = 0; i < 12 ; i++)
        {
            NSString* name = @"content";
            NSString* combine = [NSString stringWithFormat:@"%@ %d", name, i];
            [chatCon addObject:combine];
        }
        NSDictionary* initData = [[NSDictionary alloc]initWithObjects:chatCon forKeys:chatCon];
        NSLog(@"%@", initData);

        
        server_sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        
        bzero(&serveraddr, sizeof(serveraddr));
        serveraddr.sin_family = AF_INET;
        serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
        serveraddr.sin_port = htons(8000);
        
        if((bind(server_sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr))) == -1)
           {
               printf("error : %d \n", errno);
           }else
           {
               printf("bind\n");
           };
        
        if((listen(server_sockfd, 5)) == 0)
        {
            printf("Listen\n");
        }else{
            printf("Losten fail\n");
        };
        
        while(1){
            printf("wait.... \n");
            memset(buf, 0x00, 1024);
            client_sockfd = accept(server_sockfd, (struct sockaddr*) &clientaddr, &client_len);
            write(client_sockfd, (__bridge const void *)initData,sizeof(chatCon));
            
            
            printf("%d\n", client_sockfd);
            read(client_sockfd, buf, 1024);
            NSLog(@"%s", buf);
            
        }
        close(client_sockfd);
        close(server_sockfd);
        
    }
    return 0;
}

