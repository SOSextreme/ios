#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "mixers/Apple/AudioMixer.h"
#import "mixers/GenericAudioMixer.h"
#import "mixers/IAudioMixer.hpp"
#import "mixers/IMixer.hpp"
#import "mixers/iOS/GLESVideoMixer.h"
#import "mixers/IVideoMixer.hpp"
#import "rtmp/RTMPSession.h"
#import "rtmp/RTMPTypes.h"
#import "sources/Apple/PixelBufferSource.h"
#import "sources/iOS/CameraSource.h"
#import "sources/iOS/GLESUtil.h"
#import "sources/iOS/MicSource.h"
#import "sources/ISource.hpp"
#import "stream/Apple/StreamSession.h"
#import "stream/IStreamSession.hpp"
#import "stream/IThroughputAdaptation.h"
#import "stream/TCPThroughputAdaptation.h"
#import "system/Buffer.hpp"
#import "system/h264/Golomb.h"
#import "system/JobQueue.hpp"
#import "system/Logger.hpp"
#import "system/pixelBuffer/Apple/PixelBuffer.h"
#import "system/pixelBuffer/GenericPixelBuffer.h"
#import "system/pixelBuffer/IPixelBuffer.hpp"
#import "system/PreBuffer.hpp"
#import "system/util.h"
#import "transforms/Apple/H264Encode.h"
#import "transforms/Apple/MP4Multiplexer.h"
#import "transforms/AspectTransform.h"
#import "transforms/IEncoder.hpp"
#import "transforms/IMetaData.hpp"
#import "transforms/iOS/AACEncode.h"
#import "transforms/iOS/H264Encode.h"
#import "transforms/IOutput.hpp"
#import "transforms/IOutputSession.hpp"
#import "transforms/ITransform.hpp"
#import "transforms/PositionTransform.h"
#import "transforms/RTMP/AACPacketizer.h"
#import "transforms/RTMP/H264Packetizer.h"
#import "transforms/Split.h"
#import "api/iOS/VCPreviewView.h"
#import "api/iOS/VCSimpleSession.h"
#import "filters/Basic/BasicVideoFilterBGRA.h"
#import "filters/Basic/BasicVideoFilterBGRAinYUVAout.h"
#import "filters/Basic/FisheyeVideoFilter.h"
#import "filters/Basic/GlowVideoFilter.h"
#import "filters/Basic/GrayscaleVideoFilter.h"
#import "filters/Basic/InvertColorsVideoFilter.h"
#import "filters/Basic/SepiaVideoFilter.h"
#import "filters/FilterFactory.h"
#import "filters/IFilter.hpp"
#import "filters/IVideoFilter.hpp"

FOUNDATION_EXPORT double videocoreVersionNumber;
FOUNDATION_EXPORT const unsigned char videocoreVersionString[];

