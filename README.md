# cordova-plugin-snapchat-creativekit
Cordova plugin for Snapchat CreativeKit

Creative Kit SDK Docs: https://docs.snap.com/snap-kit/creative-kit/overview

## Supported platforms
- iOS

## Installation
```
cordova plugin add https://github.com/altrulife/cordova-plugin-snapchat-creativekit
```

## (Required) Add SCSDKClientId to config.xml so Snapchat will allowed to be opened with your Share data
```
<platform name="ios">
    <config-file target="*-Info.plist" parent="SCSDKClientId">
        <string>YOUR_CLIENT_ID</string>
    </config-file>
</platform>
```

## (Optional) Add SCSDKRedirectUrl to config.xml to handle errors from Snapchat
```
<platform name="ios">
    <config-file target="*-Info.plist" parent="SCSDKRedirectUrl">
        <string>YOUR_REDIRECT_URL</string>
    </config-file>
</platform>
```

## Usage from JS

### sharePhoto (no video yet)
A Snap with a still image or video is displayed in Snapchat’s preview screen, where the user can make the final modifications before sending it. Your app can add metadata or overlays — like caption text, sticker images, and attachment URLs — to embed with the Snap.

Media Size and Length Restrictions
- Shared media must be 300 MB or smaller.
- Videos must be 60 seconds or shorter.
- Videos that are longer than 10 seconds are split up into multiple Snaps of 10 seconds or less
- Preferred File Types
- Images must be JPEG or PNG
- Videos must be MP4 or MOV

```
cordova.plugins.creativekit.sharePhoto(
    {
        content: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
        },
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        sticker: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
            // not implemented
            // width: 300,
            // height: 300,
            // posX: 0.5,
            // posY: 0.6,
            // rotationDegreesInClockwise: 0,
            // isAnimated: false,
        },
    },
    () => console.log('success'),
    () => console.log('error')
);
```

### shareToCameraPreview
Send users right into the live camera on Snapchat and allow them to add sticker overlays, caption text, and attachment URLs to any Snap content type.

Limitations
- Only one sticker is allowed at a time
- Stickers must be PNG or JPEG
- An animated sticker (currently only supported on iOS) must be WebP (preferred) or GIF
- Stickers must be 1MB or smaller
- Captions are limited to 250 characters
- Attachment URLs must be properly formatted URLs in string format
- Universal links are not supported

```
cordova.plugins.creativekit.shareToCameraPreview(
    {
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
        sticker: {
            uri: 'uri string', // ie: data:image/png;base64, iVBORw0KGgoAAAANSU...
            // not implemented
            // width: 300,
            // height: 300,
            // posX: 0.5,
            // posY: 0.6,
            // rotationDegreesInClockwise: 0,
            // isAnimated: false,
        },
    },
    () => console.log('success'),
    () => console.log('error')
);
```

### shareLensToCameraPreview (not implemented yet)
You are able to add Lens attachments so that users will open Snapchat to specific Lenses! To enable sharing with Dynamic Lenses, you must first create and publish a Lens using Lens Studio. You can choose to add captions or a URL attachment to a Lens, but stickers and background photos or videos are disabled in this flow. In addition, you may optionally include launch data with the Lens attachment, to add other attributes to the Lens, like hints, for example.

Conditions
- Stickers are not allowed
- Captions are limited to 250 characters
- Attachment URLs must be properly formatted URLs in string format
- Universal links are not supported
- Launch data can be added in key-value pairs. The key must be a string and the value can be an int, float, double, string, or an array of any one of those types

```
cordova.plugins.creativekit.shareLensToCameraPreview(
    {
        lensUUID: 'uuid string',
        launchData: {
            hair_color: '#b76e79',
            hint: 'lens_hint_raise_your_eyebrows',
            // ... etc
        },
        attachmentUrl: 'url string', // any URL to attach ie: https://www.snapchat.com
        caption: 'Hi I am a caption bar on Snapchat',
    },
    () => console.log('success'),
    () => console.log('error')
);
```