//
//  GWASISender.m
//  GewaraCore
//
//  Created by wushengtao on 16/2/2.
//  Copyright © 2016年 __MyCompanyName__. All rights reserved.
//

#if __has_include(<ASIHTTPRequest.h>)

#import "GWASIMsgCreator.h"
#import "GWBaseProvider.h"
#import "NSDictionary+FormatString.h"
#import "ASIFormDataRequest.h"

@implementation GWASIMsgCreator

- (void)dealloc
{
    _responseDelegate = nil;
    _progressDelegate = nil;
    
}

#pragma mark config request
- (void)configureRequest:(ASIHTTPRequest *)request
            withProvider:(GWBaseProvider*)provider
{
    if([provider.fileDownloadPath length])
    {
        request.allowResumeForFileDownloads = provider.allowResumeForFileDownloads;
        request.temporaryFileDownloadPath = provider.temporaryFileDownloadPath;
        request.downloadDestinationPath = provider.fileDownloadPath;
    }
    request.delegate = self;
    request.downloadProgressDelegate = self;
//    request.uploadProgressDelegate = self;
    [request setTimeOutSeconds:provider.timeOutSeconds];
    for(NSString* key in provider.requestHeaders)
    {
        [request addRequestHeader:key value:provider.requestHeaders[key]];
    }
    
    request.queuePriority = provider.requestPriority;
}

#pragma mark GWProviderManagerRequestDelegate
- (void)cancelRequest:(NSObject*)request
{
    [((ASIHTTPRequest*)request) cancel];
}

- (NSOperation*)operationWithProvider:(GWBaseProvider*)provider
                           withUrlStr:(NSMutableString*)urlStr
                           withParams:(NSDictionary*)params
{
    
 
    
    if([provider.httpMethod isEqualToString:HttpMethodGet])
    {
        [urlStr setString:[NSString stringWithFormat:@"%@%@", urlStr, [params urlString]]];
        [urlStr setString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        [request setValidatesSecureCertificate:NO];
        
        [request setAllowCompressedResponse:YES];
        request.shouldCompressRequestBody = YES;
        [self configureRequest:request withProvider:provider];
        provider.operation = request;
        [request startAsynchronous];
        
#ifdef __PRINTF_REQUEST_URL__
        NSLog(@"get b: %@", [provider valueForKey:@"method"]);
#endif
        return request;
    }
    else
    {
        ASIFormDataRequest* formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [formRequest setValidatesSecureCertificate:NO];
        [self configureRequest:formRequest withProvider:provider];
        NSArray* keys = [params allKeys];
        for(NSString *key in keys)
        {
            if([provider isUploadFileUrlProperty:key])
            {
                [formRequest setFile:[params objectForKey:key]
                        withFileName:[provider fileNameWithFileProperty:key]
                      andContentType:[provider contentTypeWithFileProperty:key]
                              forKey:key];
            }
            else
            {
                [formRequest setPostValue:[params objectForKey:key] forKey:key];
            }
        }
        provider.operation = formRequest;
        [formRequest startAsynchronous];
        
#ifdef __PRINTF_REQUEST_URL__
        NSLog(@"post b: %@", [provider valueForKey:@"method"]);
#endif
        return formRequest;
    }
    
    return nil;
}

- (NSInteger)responseStatusCodeWithRequest:(NSOperation*)request
{
    return ((ASIHTTPRequest*)request).responseStatusCode;
}

- (NSString*)responseStringWithRequest:(NSOperation*)request
{
    return ((ASIHTTPRequest*)request).responseString;
}
- (NSData*)responseDataWithRequest:(NSOperation*)request
{
    return ((ASIHTTPRequest*)request).responseData;
}


#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if([_responseDelegate respondsToSelector:@selector(requestStarted:)])
    {
        [_responseDelegate requestStarted:request];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([_responseDelegate respondsToSelector:@selector(requestFinished:)])
    {
        [_responseDelegate requestFinished:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([_responseDelegate respondsToSelector:@selector(requestFailed:error:)])
    {
        [_responseDelegate requestFailed:request error:request.error];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if([_responseDelegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)])
    {
        [_responseDelegate request:request didReceiveResponseHeaders:responseHeaders];
    }
}

#pragma mark ASIProgressDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    if([_progressDelegate respondsToSelector:@selector(request:didReceiveBytes:totalBytes:)])
    {
        [_progressDelegate request:request
                   didReceiveBytes:[request totalBytesRead] + [request partialDownloadSize]
                        totalBytes:[request contentLength] + [request partialDownloadSize]];
    }
}
@end
#endif