//
//  CameraViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit
import Photos
import AVFoundation

class CameraViewController: BaseVC {
    //MARK: - Properties
    //Views
    @IBOutlet weak var makePhotoButton: UIButton!
    @IBOutlet weak var returnCameraButton: UIButton!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lastLibraryPhoto: UIImageView!
    
    //Variables
    //last images
    var lastLibraryImage: UIImage? = nil
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    var output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // CaptureDevice
    var captureDevice: AVCaptureDevice!
    
    var usingFrontCamera = true
    var takenPhoto: UIImage?
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async { [self] in
            //Preview layer
            view.backgroundColor = .black
            view.layer.addSublayer(previewLayer)
            
            //layers
            lastLibraryPhoto.layer.cornerRadius = 4
            
            //actions
            backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
            makePhotoButton.addTarget(self, action: #selector(didTapTakePhoto(_:)), for: .touchUpInside)
            returnCameraButton.addTarget(self, action: #selector(returnCameraAction(_:)), for: .touchUpInside)
            
            //Gesture
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectPhotos(_:)))
            lastLibraryPhoto.isUserInteractionEnabled = true
            lastLibraryPhoto.addGestureRecognizer(gesture)
            
            //setupCamera
            checkCameraPermissions()
            
            //add shape layer
            let width: CGFloat = view.frame.size.width
            let height: CGFloat = view.frame.size.height

            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), cornerRadius: 0)
            let rect = CGRect(x: width / 2 - 141.5, y: height / 2.5 - 100, width:  283, height: 356)
            let circlePath = UIBezierPath(ovalIn: rect)
            path.append(circlePath)
            path.usesEvenOddFillRule = true
            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.fillRule = .evenOdd
            fillLayer.fillColor = UIColor.black.cgColor
            fillLayer.opacity = 0.5
            view.layer.addSublayer(fillLayer)
            
            //addSubViewAgain
            view.addSubview(backButton)
            view.addSubview(itemsView)
            
            //setupLastLibraryPhoto
            fetchPhotos()
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        session?.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        session?.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoResultViewC" {
            guard let viewController = segue.destination as? PhotoResultViewController else { return print("no view found!!!") }
            viewController.modalTransitionStyle = .flipHorizontal
            viewController.selectedImage = self.takenPhoto
        }
    }
    
    //MARK: - Public Functions
    //setupCamera
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                // Request
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    guard granted else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                setUpCamera()
            @unknown default:
                break
        }
    }

    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
        return videoDevice
    }

    func getBackCamera() -> AVCaptureDevice?{
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.first
        return videoDevice
    }

    func setUpCamera() {
        let session = AVCaptureSession()
        let session1 = AVCaptureSession()
        let output = AVCapturePhotoOutput()
        let output1 = AVCapturePhotoOutput()

        if usingFrontCamera {
            if let device = getFrontCamera() {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(output) {
                        session.addOutput(output)
                    }
                    
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer.session = session
                    session.startRunning()
                    self.output = output
                    self.session = session
                } catch {
                    print(error)
                }
            }
        } else {
            if let device = getBackCamera() {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if (session1.canAddInput(input)) {
                        session1.addInput(input)
                    }

                    if (session1.canAddOutput(output1))  {
                        session1.addOutput(output1)
                    }
                    
                    previewLayer.videoGravity = .resizeAspectFill
                    previewLayer.session = session1
                    session1.startRunning()
                    self.output = output1
                    self.session = session1
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.showViewController(storyboardName: "Main", viewController: "TabbarViewController")
        }
    }
    
    @objc func didSelectPhotos(_ sender: Any) {
        let libraryControllerFirst = UIImagePickerController()
                libraryControllerFirst.sourceType = .photoLibrary
                libraryControllerFirst.delegate = self
                libraryControllerFirst.allowsEditing = false
        present(libraryControllerFirst, animated: true, completion: nil)
    }
    
    @objc func returnCameraAction(_ sender: UIButton) {
        usingFrontCamera = !usingFrontCamera
        setUpCamera()
    }
    
    @objc func didTapTakePhoto(_ sender: UIButton) {
        self.previewLayer.connection?.output?.connection(with: .video)?.isVideoMirrored = false
        if usingFrontCamera {
            output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        } else {
            output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    
    //MARK: - Fetch Last Library Photo
    func fetchPhotos () {
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 3

        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 3 // <-- The number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }

    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.lastLibraryPhoto.image = image
            }
        })
    }
    
    //MARK: - EndPhoto
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        //StartSession
        session?.startRunning()
    }
}

//MARK: - Image Picker Delegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
            if let selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
                
                self.takenPhoto = selectedImage
                
                self.performSegue(withIdentifier: "photoResultViewC", sender: nil)
            }
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)
        session?.stopRunning()
        let image2 = UIImage(cgImage: (image?.cgImage!)!, scale: 1.0, orientation: .leftMirrored)
        DispatchQueue.main.async {
            self.takenPhoto = image2
            
            self.performSegue(withIdentifier: "photoResultViewC", sender: nil)
        }
    }
}

