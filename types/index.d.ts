
export type ContentData = {
    uri: string;
};
export type StickerData = {
     uri: string;
     width?: number;
     height?: number;
     posX?: number;
     posY?: number;
     rotation?: number;
     // isAnimated: false,
};
export type SharePhotoData = {
    content: ContentData,
    sticker?: StickerData,
    caption?: string;
    attachmentUrl?: string;
    topics?: string[];
};
export type ShareVideoData = {
    content: ContentData,
    sticker?: StickerData,
    caption?: string;
    attachmentUrl?: string;
    topics?: string[];
};
export type ShareToCameraPreviewData = {
    sticker?: StickerData,
    caption?: string;
    attachmentUrl?: string;
    topics?: string[];
};
export type ShareLensToCameraPreviewData = {
    lensUUID: string;
    launchData?: Record<string, number | string | string[] | number[]>;
    caption?: string;
    attachmentUrl?: string;
    topics?: string[];
};
export type PluginCallback = (msg: string) => void;
export type CreativeKitApi = {
    sharePhoto: (data: SharePhotoData, successCb: PluginCallback, errorCb: PluginCallback) => void;
    shareVideo: (data: ShareVideoData, successCb: PluginCallback, errorCb: PluginCallback) => void;
    shareToCameraPreview: (data: ShareToCameraPreviewData, successCb: PluginCallback, errorCb: PluginCallback) => void;
    shareLensToCameraPreview: (data: ShareLensToCameraPreviewData, successCb: PluginCallback, errorCb: PluginCallback) => void;
};
export type CreativeKitCordovaPlugin = {
    cordova?: {
        plugins?: {
            creativekit?: CreativeKitApi;
        };
    };
};
