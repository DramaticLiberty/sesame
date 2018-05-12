//
//  Capture.swift
//  Runner
//
//  Created by m on 4/28/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AVKit
import Vision

protocol CaptureDelegate: class {
    func captured(_ results: [Any]?)
    func sessionSetup(_ session: AVCaptureSession)
}

class Capture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: CaptureDelegate?
    var frameDelay: CMTime
    var model: VNCoreMLModel
    var request: VNCoreMLRequest?
    var lastFrameTime = CMTimeMake(1, Int32(1))
    let processingMutex = DispatchSemaphore(value: 1)

    init(_ model: MLModel, _ delegate: CaptureDelegate?, _ fps: Int = 10) throws {
        self.delegate = delegate
        self.frameDelay = CMTimeMake(1, Int32(fps))
        self.model = try VNCoreMLModel(for: model)
    }

    convenience init(yolo delegate: CaptureDelegate?, _ fps: Int = 10) throws {
        try self.init(yolo().model, delegate, fps)
    }

    convenience init(mobileNet delegate: CaptureDelegate?, _ fps: Int = 10) throws {
        try self.init(MobileNet().model, delegate, fps)
    }

    func capture() {
        // position: .front
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let input = try? AVCaptureDeviceInput(device: device)
        else {
            return;
        }

        self.request = VNCoreMLRequest(model: self.model) { (req, error) in
            self.delegate?.captured(req.results)
            self.processingMutex.signal()
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        output.alwaysDiscardsLateVideoFrames = true


        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        // captureSession.sessionPreset = .photo
        captureSession.sessionPreset = .medium
        captureSession.addInput(input)
        captureSession.addOutput(output)
        output.connection(with: AVMediaType.video)?.videoOrientation = .portrait

        self.delegate?.sessionSetup(captureSession)
        captureSession.commitConfiguration()

        captureSession.startRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let currentFrameTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        guard
            (currentFrameTime - lastFrameTime) >= self.frameDelay,
            self.processingMutex.wait(timeout: DispatchTime.now()) == .success,
            let buf = CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return
        }

        DispatchQueue.global().async {
            self.lastFrameTime = currentFrameTime
            try? VNImageRequestHandler(cvPixelBuffer: buf, options: [:]).perform([self.request!])
        }
    }
}
