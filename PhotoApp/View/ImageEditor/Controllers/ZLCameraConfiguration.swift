//
//  ZLCameraConfiguration.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import AVFoundation

public class ZLCameraConfiguration: NSObject {
    
    @objc public enum CaptureSessionPreset: Int {
        
        var avSessionPreset: AVCaptureSession.Preset {
            switch self {
            case .cif352x288:
                return .cif352x288
            case .vga640x480:
                return .vga640x480
            case .hd1280x720:
                return .hd1280x720
            case .hd1920x1080:
                return .hd1920x1080
            case .hd4K3840x2160:
                return .hd4K3840x2160
            }
        }
        
        case cif352x288
        case vga640x480
        case hd1280x720
        case hd1920x1080
        case hd4K3840x2160
    }
    
    @objc public enum FocusMode: Int  {
        
        var avFocusMode: AVCaptureDevice.FocusMode {
            switch self {
            case .autoFocus:
                return .autoFocus
            case .continuousAutoFocus:
                return .continuousAutoFocus
            }
        }
        
        case autoFocus
        case continuousAutoFocus
    }
    
    @objc public enum ExposureMode: Int  {
        
        var avFocusMode: AVCaptureDevice.ExposureMode {
            switch self {
            case .autoExpose:
                return .autoExpose
            case .continuousAutoExposure:
                return .continuousAutoExposure
            }
        }
        
        case autoExpose
        case continuousAutoExposure
    }
    
    @objc public enum FlashMode: Int  {
        
        var avFlashMode: AVCaptureDevice.FlashMode {
            switch self {
            case .auto:
                return .auto
            case .on:
                return .on
            case .off:
                return .off
            }
        }
        
        // 转系统相机
        var imagePickerFlashMode: UIImagePickerController.CameraFlashMode {
            switch self {
            case .auto:
                return .auto
            case .on:
                return .on
            case .off:
                return .off
            }
        }
        
        case auto
        case on
        case off
    }
    
    @objc public enum VideoExportType: Int {
        
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
    
    /// Video resolution. Defaults to hd1280x720.
    @objc public var sessionPreset: ZLCameraConfiguration.CaptureSessionPreset
    
    /// Camera focus mode. Defaults to continuousAutoFocus
    @objc public var focusMode: ZLCameraConfiguration.FocusMode
    
    /// Camera exposure mode. Defaults to continuousAutoExposure
    @objc public var exposureMode: ZLCameraConfiguration.ExposureMode
    
    /// Camera flahs mode. Default is off. Defaults to off.
    @objc public var flashMode: ZLCameraConfiguration.FlashMode
    
    /// Video export format for recording video and editing video. Defaults to mov.
    @objc public var videoExportType: ZLCameraConfiguration.VideoExportType
    
    @objc public init(
        sessionPreset: ZLCameraConfiguration.CaptureSessionPreset = .hd1280x720,
        focusMode: ZLCameraConfiguration.FocusMode = .continuousAutoFocus,
        exposureMode: ZLCameraConfiguration.ExposureMode = .continuousAutoExposure,
        flashMode: ZLCameraConfiguration.FlashMode = .off,
        videoExportType: ZLCameraConfiguration.VideoExportType = .mov
    ) {
        self.sessionPreset = sessionPreset
        self.focusMode = focusMode
        self.exposureMode = exposureMode
        self.flashMode = flashMode
        self.videoExportType = videoExportType
        super.init()
    }
    
}

