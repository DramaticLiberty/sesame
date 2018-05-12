import UIKit
import Flutter
import AVKit
import Vision
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image: UIImage?
    var result: FlutterResult?
    var picker: UIImagePickerController?
    var capture: Capture?
    var helper: Yolo2Helper?

    func takePhoto(_ controller: UIViewController, _ result: @escaping FlutterResult) {
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                picker.sourceType = .camera
                controller.present(picker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            picker.sourceType = .photoLibrary
            // on iPad we are required to present this as a popover
            if UIDevice.current.userInterfaceIdiom == .pad {
                picker.modalPresentationStyle = .popover
                picker.popoverPresentationController?.sourceView = controller.view
                picker.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 10, height: 10)
            }
            controller.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // on iPad this is a popover
        alert.popoverPresentationController?.sourceView = controller.view
        picker.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        controller.present(alert, animated: true, completion: nil)
        self.picker = picker
        self.result = result
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.result!(info[UIImagePickerControllerMediaType])
        self.picker!.dismiss(animated: true, completion: nil)
        self.picker = nil
        self.result = nil
    }

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure();
        GeneratedPluginRegistrant.register(with: self)
        self.capture = try? Capture(yolo().model, self, 10)
        self.helper = Yolo2Helper()

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;
        let visionChannel = FlutterMethodChannel.init(name: "mypt.aeliptus.com/vision", binaryMessenger: controller);
        visionChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Handle messages
            if call.method == "faces" {
                if let arg = call.arguments {
                    self.capture?.capture()
                    // self.takePhoto(controller, result)
                } else {
                    result(FlutterError.init(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil));
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        });
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func captured(_ results: [Any]?) {
        // MobileNet has results of VNClassificationObservation
        // yolo has results of VNCoreMLFeatureValueObservation
        guard
            let observations = results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue
        else {
            return
        }
        DispatchQueue.main.async {
            let boundingBoxes = self.helper!.computeBoundingBoxes(features: features)
            let trafic = boundingBoxes.filter({ $0.isTrafic() })
            if !trafic.isEmpty {

                print(boundingBoxes)
            }
        }
    }

    func sessionSetup(_ captureSession: AVCaptureSession) {
        guard let controller = window?.rootViewController else { return }
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = AVLayerVideoGravity.resizeAspect
        preview.connection?.videoOrientation = .portrait
        controller.view.layer.addSublayer(preview)
        preview.frame = controller.view.frame
    }

}
