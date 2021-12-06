//
//  ZLVideoManager.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import AVFoundation
import Photos

public class ZLVideoManager: NSObject {
    
    class func getVideoExportFilePath() -> String {
        let format = ZLPhotoConfiguration.default().cameraConfiguration.videoExportType.format
        return NSTemporaryDirectory().appendingFormat("%@.%@", UUID().uuidString, format)
    }
    
    class func exportEditVideo(for asset: AVAsset, range: CMTimeRange, complete: @escaping ( (URL?, Error?) -> Void )) {
        let type: ZLVideoManager.ExportType = ZLPhotoConfiguration.default().cameraConfiguration.videoExportType == .mov ? .mov : .mp4
        self.exportVideo(for: asset, range: range, exportType: type, presetName: AVAssetExportPresetPassthrough) { url, error in
            if url != nil {
                complete(url!, error)
            } else {
                complete(nil, error)
            }
        }
    }
    
    /// 没有针对不同分辨率视频做处理，仅用于处理相机拍照的视频
    @objc public class func mergeVideos(fileUrls: [URL], completion: @escaping ( (URL?, Error?) -> Void )) {
        let mixComposition = AVMutableComposition()
        
        let assets = fileUrls.map { AVURLAsset(url: $0) }
        
        do {
            // video track
            let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            var instructions: [AVMutableVideoCompositionInstruction] = []
            var videoSize = CGSize.zero
            var start: CMTime = .zero
            for asset in assets {
                let videoTracks = asset.tracks(withMediaType: .video)
                if let assetTrack = videoTracks.first, compositionVideoTrack != nil  {
                    try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: asset.duration), of: assetTrack, at: start)
                    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
                    layerInstruction.setTransform(assetTrack.preferredTransform, at: start)
                    
                    let instruction = AVMutableVideoCompositionInstruction()
                    instruction.timeRange = CMTimeRangeMake(start: start, duration: asset.duration)
                    instruction.layerInstructions = [layerInstruction]
                    instructions.append(instruction)
                    
                    start = CMTimeAdd(start, asset.duration)
                    if videoSize == .zero {
                        videoSize = assetTrack.naturalSize
                        let info = self.orientationFromTransform(assetTrack.preferredTransform)
                        if info.isPortrait {
                            swap(&videoSize.width, &videoSize.height)
                        }
                    }
                }
            }
            
            
            let mainComposition = AVMutableVideoComposition()
            mainComposition.instructions = instructions
            mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            mainComposition.renderSize = videoSize
            
            // audio track
            let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            start = .zero
            for asset in assets {
                let audioTracks = asset.tracks(withMediaType: .audio)
                if !audioTracks.isEmpty {
                    try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: asset.duration), of: audioTracks[0], at: start)
                    start = CMTimeAdd(start, asset.duration)
                }
            }
            
            guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset1280x720) else {
                completion(nil, NSError(domain: "com.ZLPhotoBrowser.error", code: -1000, userInfo: [NSLocalizedDescriptionKey: "video merge failed"]))
                return
            }
            
            let outputUrl = URL(fileURLWithPath: ZLVideoManager.getVideoExportFilePath())
            exportSession.outputURL = outputUrl
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputFileType = ZLPhotoConfiguration.default().cameraConfiguration.videoExportType.avFileType
            exportSession.videoComposition = mainComposition
            exportSession.exportAsynchronously(completionHandler: {
                let suc = exportSession.status == .completed
                if exportSession.status == .failed {
                    zl_debugPrint("ZLPhotoBrowser: video merge failed:  \(exportSession.error?.localizedDescription ?? "")")
                }
                ZLMainAsync {
                    completion(suc ? outputUrl : nil, exportSession.error)
                }
            })
        } catch {
            completion(nil, error)
        }
    }
    
    static func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        let tfA = transform.a
        let tfB = transform.b
        let tfC = transform.c
        let tfD = transform.d
        
        if tfA == 0 && tfB == 1.0 && tfC == -1.0 && tfD == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if tfA == 0 && tfB == -1.0 && tfC == 1.0 && tfD == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if tfA == 1.0 && tfB == 0 && tfC == 0 && tfD == 1.0 {
            assetOrientation = .up
        } else if tfA == -1.0 && tfB == 0 && tfC == 0 && tfD == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
}


// MARK: export methods
extension ZLVideoManager {
    
    @objc public class func exportVideo(for asset: PHAsset, exportType: ZLVideoManager.ExportType = .mov, presetName: String = AVAssetExportPresetMediumQuality, complete: @escaping ( (URL?, Error?) -> Void )) {
        guard asset.mediaType == .video else {
            complete(nil, NSError(domain: "com.ZLPhotoBrowser.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "The mediaType of asset must be video"]))
            return
        }
        
        _ = ZLPhotoManager.fetchAVAsset(forVideo: asset) { avAsset, _ in
            if let set = avAsset {
                self.exportVideo(for: set, exportType: exportType, presetName: presetName, complete: complete)
            } else {
                complete(nil, NSError(domain: "com.ZLPhotoBrowser.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Export failed"]))
            }
        }
    }
    
    @objc public class func exportVideo(for asset: AVAsset, range: CMTimeRange = CMTimeRange(start: .zero, duration: .positiveInfinity), exportType: ZLVideoManager.ExportType = .mov, presetName: String = AVAssetExportPresetMediumQuality, complete: @escaping ( (URL?, Error?) -> Void )) {
        let outputUrl = URL(fileURLWithPath: self.getVideoExportFilePath())
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: presetName) else {
            complete(nil, NSError(domain: "com.ZLPhotoBrowser.error", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Export failed"]))
            return
        }
        exportSession.outputURL = outputUrl
        exportSession.outputFileType = exportType.avFileType
        exportSession.timeRange = range
        
        exportSession.exportAsynchronously(completionHandler: {
            let suc = exportSession.status == .completed
            if exportSession.status == .failed {
                zl_debugPrint("ZLPhotoBrowser: video export failed: \(exportSession.error?.localizedDescription ?? "")")
            }
            ZLMainAsync {
                complete(suc ? outputUrl : nil, exportSession.error)
            }
        })
    }
    
}


extension ZLVideoManager {
    
    @objc public enum ExportType: Int {
        
        var format: String {
            switch self {
            case .mov:
                return "mov"
            case .mp4:
                return "mp4"
            }
        }
        
        var avFileType: AVFileType {
            switch self {
            case .mov:
                return .mov
            case .mp4:
                return .mp4
            }
        }
        
        case mov
        case mp4
        
    }
    
}

