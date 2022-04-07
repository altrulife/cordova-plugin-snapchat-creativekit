/********* CDVCreativeKit.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <SCSDKCreativeKit/SCSDKCreativeKit.h>
#import "CDVCreativeKit.h"

@implementation CDVCreativeKit
{
    SCSDKSnapAPI *_scSdkSnapApi;
}

- (void)pluginInitialize {
    [super pluginInitialize];

    _scSdkSnapApi = [SCSDKSnapAPI new];
}


- (void) sendPluginResult: (CDVPluginResult*)result :(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) handlePluginException: (NSException*) exception :(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    NSLog(@"EXCEPTION: %@", exception.reason);
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (SCSDKSnapSticker*)createSnapSticker:(NSDictionary*)stickerMap
{
    NSString *stickerData = nil;

    if (stickerMap != nil) {
        stickerData = stickerMap[@"uri"];
    }
    
    if (stickerData == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:stickerData];
    SCSDKSnapSticker *snapSticker = [[SCSDKSnapSticker alloc] initWithStickerUrl:url isAnimated:NO];
    return snapSticker;
}

- (SCSDKPhotoSnapContent*)createSnapPhotoContent:(NSDictionary*)contentMap
{
    NSString *contentUri = nil;

    if (contentMap != nil) {
        contentUri = contentMap[@"uri"];
    }
    
    if (contentUri == nil) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:contentUri];
    SCSDKSnapPhoto *photo = [[SCSDKSnapPhoto alloc] initWithImageUrl:url];
    SCSDKPhotoSnapContent *photoContent = [[SCSDKPhotoSnapContent alloc] initWithSnapPhoto:photo];

    return photoContent;
}

- (void)sharePhoto:(CDVInvokedUrlCommand*)command
{
    @try {
        NSDictionary* metadata = [command.arguments objectAtIndex:0];
        
        if (metadata[@"content"] == nil) {
            [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] :command];
            return;
        }

        SCSDKPhotoSnapContent *snapContent = [self createSnapPhotoContent:metadata[@"content"]];
        NSLog(@"Added content");
        
        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }
        
        if (metadata[@"sticker"]) {
            SCSDKSnapSticker *snapSticker = [self createSnapSticker:metadata[@"sticker"]];
            if (snapSticker != nil) {
                snapContent.sticker = snapSticker;
                NSLog(@"Added sticker");
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}

- (void)shareToCameraPreview:(CDVInvokedUrlCommand*)command
{
   
    @try {
        SCSDKNoSnapContent *snapContent = [[SCSDKNoSnapContent alloc] init];
        NSDictionary* metadata = [command.arguments objectAtIndex:0];
        
        if (metadata[@"caption"]) {
            snapContent.caption = metadata[@"caption"];
            NSLog(@"Added caption");
        }
        
        if (metadata[@"attachmentUrl"]) {
            snapContent.attachmentUrl = metadata[@"attachmentUrl"];
            NSLog(@"Added attachmentUrl");
        }
        
        if (metadata[@"sticker"]) {
            SCSDKSnapSticker *snapSticker = [self createSnapSticker:metadata[@"sticker"]];
            if (snapSticker != nil) {
                snapContent.sticker = snapSticker;
                NSLog(@"Added sticker");
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_scSdkSnapApi startSendingContent:snapContent completionHandler:^(NSError *error){
                return;
            }];
        });

        [self sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] :command];
    }
    @catch (NSException *exception) {
        [self handlePluginException:exception :command];
    }
}
@end
