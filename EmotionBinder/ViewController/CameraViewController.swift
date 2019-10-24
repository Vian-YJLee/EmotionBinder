//
//  CameraViewController.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 23/07/2019.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit
import AVFoundation
import Dispatch
import Photos

@available(iOS 10.2, *)
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let storyboardIdentifierConstantOfEditPhotoViewController: String = "showEditPhotoViewController"
    
    
    @IBOutlet weak var filterTitleLabel: UILabel!
    
    @IBOutlet weak var settingToolbar: UIToolbar! //화면 상단. 비율, 플래시 설정 툴바
    
    @IBOutlet weak var cameracntrToolbar: UIToolbar! //화면 하단. 카메라 전환, 앨범
    
    @IBOutlet weak var flashSetBarbButtonItem: UIBarButtonItem! //플래시 모드 설정 버튼
    
    @IBOutlet weak var ratioSetBarButtonItem: UIBarButtonItem! // 사진 비율 조정 버튼
   
    @IBOutlet weak var emojiEditorBarButtonItem: UIBarButtonItem! // 이모지, 미모지 모드(애플이 권한을 줄까?)
    
    @IBOutlet weak var photoLibraryBarButtonItem: UIBarButtonItem! // 사진앨범 진입버튼
    
    @IBOutlet weak var shutterBarButtonItem: UIBarButtonItem! // 카메라 셔터
    
    @IBOutlet weak var cameraSwichBarbuttonItem: UIBarButtonItem! //전후방 카메라 전환버튼
    
    @IBOutlet weak var cameraPreview: UIImageView! // 카메라로 비춰지는 화면 프리뷰
    
    
    var focusBox: UIView! //포커스 박스 커스텀 프로퍼티
    var emojiFaceIcon: UIImageView?
    var isAddFunEmoticon: Bool?
    var originalImage: UIImage?
    var filterTitle: String? //필터 이름 지정
    var filterIndex: Int? // 현재 필터를 저장해둘 인덱스 변수. 스와이프 기능으로 동작할 때 사용
    var cameraPosition: AVCaptureDevice.Position?
    var flashSwitchStatus: Int = 0 // 플래시 모드(항상끔 켬 등..)의 상태 저장하는 프로퍼티
    //온오프 구분을 위해 extension으로 프로토콜을 추가해 conformance하도록 구성
    
    var screenRatioStatus: Int = 0 // 화면 비율조정 상태 저장 프로퍼티
    var authorizationStatus: AVAuthorizationStatus? // 카메라 실행 전 권한 묻기 : 개발 가이드 강제사항..안하면 리젝
    var previewImage: CGRect?
    
    var captureDevice: AVCaptureDevice? // 물리적 캡쳐 장치 및 해당 장치와 관련된 속성. 캡쳐 장치를 사용하여 기본 하드웨어 속성을 구성함. AVCaptrueSesstion 객체에 비디오 또는 오디오의 입력데이터 전달 역할
    var captureSession: AVCaptureSession?
    // 비디오 장치로부터 데이터 출력의 흐름 조정하는 AVCaptureSession 객체
    var sessionOutput: AVCapturePhotoOutput?
    // 스틸 이미지(사진)와 관련해 최신 캡쳐 인터페이스 워크 플로우를 제공하는 AVCaptureOutput의 하위클래스. 카메라 화질, 저장방식, Flash 사용 유무 여부 등을 제어함
    var previewLayer = AVCaptureVideoPreviewLayer() // CALayer의 서브클래스. 입력장치로부터 캡쳐된 비디오를 표시하는데 사용
    //developer.apple.com의 AVFoundation 문서 참조
    var captureSetting: AVCapturePhotoSettings?
    //이미지 촬영(캡쳐)시 사용될 동작(플래시 발광 등)과 사진 저장에 필요한 각종 이미지 데이터(저장할 이미지 해상도, 화질 등등) 셋팅값들을 제어하는 클래스
    
 
    var cameraView: UIView!
    
    var protection: String?
    
    //상태 바 숨김
    var isHidden: Bool = true{
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        flashSwitchStatus = FlashModeCheck.off.rawValue // Init
        
        
        
    }
    
    //MAKR: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /*
        captureSession = AVCaptureSession()
        
         var sessionOutput = AVCapturePhotoOutput()
         // 스틸 이미지(사진)와 관련해 최신 캡쳐 인터페이스 워크 플로우를 제공하는 AVCaptureOutput의 하위클래스. 카메라 화질, 저장방식, Flash 사용 유무 여부 등을 제어함
         var previewLayer = AVCaptureVideoPreviewLayer() // CALayer의 서브클래스. 입력장치로부터 캡쳐된 비디오를 표시하는데 사용
                    */
        print("viewWillAppear in CameraViewController")
        
        //카메라 사용여부 확인 (권한, 작동)
        let availavleCameraHardware:Bool = UIImagePickerController.isSourceTypeAvailable(.camera)
        shutterBarButtonItem.isEnabled = availavleCameraHardware
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if let authorizationStatusOfCamera = authorizationStatus, availavleCameraHardware {
            switch authorizationStatusOfCamera {
            case .authorized:
                print(authorizationStatusOfCamera)
                setUpcamera()
                
            case .denied:
                print(authorizationStatusOfCamera)
                
                showNotice(alertCase: .Camera) // 접근 권한이 없으므로 사용자에게 설정 - 앱 - 카메라 허가 요청 UIAlertController 호출
                
                disableCameraOptionButton() // flash, camera rotate swich 버튼 비활성화
                
            case .notDetermined:
                print(authorizationStatusOfCamera)
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                    
                    if granted {
                        
                        // GCD
                        DispatchQueue.main.async {
                            self.setUpcamera() // 카메라 셋업
                        }
                        
                    } else {
                        print(granted)
                        
                        //GCD
                        DispatchQueue.main.async {
                            self.disableCameraOptionButton()
                            
                        }
                    }
                    
                })
                
            case .restricted:
                print(authorizationStatusOfCamera)
            }
        }
    }
        
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidApper in CameraViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("vidwWillDisappear in CameraViewContoller")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear in CameraViewController")
    }
    
    //캡쳐
    
    @IBAction func takePhoto(_ sender: Any) {
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if let authorizationStatusOfCamera = authorizationStatus {
            
            switch authorizationStatusOfCamera {
            case .authorized:
                print(authorizationStatusOfCamera)
                
                captureSetting = AVCapturePhotoSettings()
                
                DispatchQueue.main.async {
                    if let photoCaptureSetting = self.captureSetting, let capturePhotoOutput = self.sessionOutput {
                        
                        photoCaptureSetting.flashMode = self.getFlashModeConstants(self.flashSwitchStatus)
                        photoCaptureSetting.isAutoStillImageStabilizationEnabled = true
                        photoCaptureSetting.isHighResolutionPhotoEnabled = false
                        
                        capturePhotoOutput.capturePhoto(with: photoCaptureSetting, delegate: self)
                    }
                }
                
            case .denied:
                print(authorizationStatusOfCamera)
                showNotice(alertCase: .Camera)
                
            default:
                return
            }
        }
    }
    
    @IBAction func flashModeStatus(_ sender: Any) {
        //좀 더 확실한 이름 구분이 필요할 것 같은데
        flashSwitchStatus += 1
        flashSwitchStatus %= 3
        // off 상태 값을 0으로 설정 1은 on, 나머지 연산으로 2가 나왔을 경우 자동모드
        
        switch flashSwitchStatus {
        case FlashModeCheck.off.rawValue:
            flashSetBarbButtonItem.image = UIImage(named: "FlashOff.png")
        
        case FlashModeCheck.on.rawValue: flashSetBarbButtonItem.image = UIImage(named: "FlashOn.png")
        
        case FlashModeCheck.auto.rawValue: flashSetBarbButtonItem.image = UIImage(named: "FlashAuto.png")
            
        default:
            break;
        }
    }
    
    @IBAction func switchCameraEffect(_ sender: Any) {
        
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizer.Direction.left:
                print("Left Swipe")
            case UISwipeGestureRecognizer.Direction.right:
                print("Right Swipe")
        
            default:
                return
            }
    }
}
    
    //카메라 취소 (모달뷰 다운)
    @IBAction func cancelCamera(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func swichCameraPosition(_ sender: Any) {
        
        if let session = captureSession {
            // Indicate that some change will be made to the session
            session.beginConfiguration()
            
            // Remove existing input
            let presentCameraInput: AVCaptureInput = session.inputs.first as! AVCaptureInput
            session.removeInput(presentCameraInput)
            
            // Get new input
            //var newCameraInput:AVCaptureDevice! = nil
            
            captureDevice = nil
            
            //이미지 사이즈 설정 참조 https://developer.apple.com/documentation/avfoundation/avcapturesession/preset

            if let input = presentCameraInput as? AVCaptureDeviceInput {
                if(input.device.position == .back) {
                    captureDevice = cameraSwichingPosition(position: .front)
                    session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                }else if(input.device.position == .front) {
                    
                    captureDevice = cameraSwichingPosition(position: .back)
                    session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                
                }
            }
            
            //Add input to session
            
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            
            do {
                newVideoInput = try AVCaptureDeviceInput(device: captureDevice!)
            }catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if(newVideoInput == nil || err != nil) {
                print("Error creating capture device input: \(err!.localizedDescription)")
            } else {
                session.addInput(newVideoInput)
            }
            //commit all the configuration changes at once
            
            session.commitConfiguration()
            
            }
        }
    
    func disableCameraOptionButton() {
        cameraSwichBarbuttonItem.isEnabled = false
        flashSetBarbButtonItem.isEnabled = false
    }
    
    
    func setUpcamera() {
        
        cameraSwichBarbuttonItem.isEnabled = true
        flashSetBarbButtonItem.isEnabled = true
        
        captureSession = AVCaptureSession()
        sessionOutput = AVCapturePhotoOutput()
        previewLayer = AVCaptureVideoPreviewLayer()
        
        if let session = captureSession {
            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            
            let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDuoCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera, AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            
            if let session = captureSession { //카메라 front, back 상태를 저장하는 프로퍼티
                for discoveredDevice in (deviceSession.devices) {
                    
                    if discoveredDevice.position == AVCaptureDevice.Position.back {
                        captureDevice = discoveredDevice // Device setting
                        
                        do {
                            let input = try AVCaptureDeviceInput(device: discoveredDevice)
                            if session.canAddInput(input) {
                                session.addInput(input)
                                
                                if session.canAddOutput(sessionOutput!) {
                                    session.addOutput(sessionOutput!)
                                    
                                    previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                                
                                    let captureVideoPreveiwLayer = previewLayer
                                        
                                        captureVideoPreveiwLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                        captureVideoPreveiwLayer.connection?.videoOrientation = .portrait
                                    
                                    cameraView.layer.addSublayer(previewLayer)
                                    
                                    captureVideoPreveiwLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                                    
                                        captureVideoPreveiwLayer.frame = cameraView.bounds
                                    
                                    session.startRunning()
                                    
                                    }
                                }
                        }  catch let avCaptureError {
                            print(avCaptureError)
                    }
                    }
                }
            }
        }
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    @available(iOS 10.2, *)
    func cameraSwichingPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera, AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in (deviceSession.devices) {
            
            if device.position == position {
                return device
            }
            return nil
        }
        
        // AVCapturePhotoCaptureDelegate Method for Image Saving
        
        func capture(_: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer PhotoSampleBuffer: CMSampleBuffer?, previewPhtoSampleBuffer: CMSampleBuffer?, resolvedsettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCapturePhotoBracketSettings?, error: Error?) {
            
            if let photoSampleBuffer = PhotoSampleBuffer {
                let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: PhotoSampleBuffer!, previewPhotoSampleBuffer: previewPhtoSampleBuffer)
                let takedPhotoImage = UIImage(data: photoData!)
                
                
                if let image = takedPhotoImage {
                    
                    switch PHPhotoLibrary.authorizationStatus() {
                    case .authorized:
                        //설정 - 사진승인 상태이기에 앨범에 저장, 이동
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
                    case .denied, .notDetermined:
                        // 설정 - 미승인 상태. 앨범에 저장하지 않고 다음 화면으로 바로 이동
                        
                        navigateToFilterViewControllerWithResizeImage(Source: image)
                        
                    default:
                        return
                       
                    }
                }
            }
        }
        
        // UIImageWriteToSavedPhotosAlbum 수행 후 completionSelector 수행
        func saveCompleted(_ image: UIImage, didFinishSaveingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
            dump(image)
            
            navigateToFilterViewControllerWithResizeImage(Source: image)
        }
        
        func navigateToFilterViewControllerWithResizeImage(Source image: UIImage) {
            let resizeImage = image.resizeImage(targetSize: CGSize(width: 64, height: 64))
            
            if let editPhotoViewController = storyboard?.instantiateInitialViewController(withIdentifier: storyboardIdentifierConstantOfEditPhotoViewController) as? EditPhotoViewController {
                
                editPhotoViewController.takenPhotoImge = image
                editPhotoViewController.takenResizedPhotoImage = resizeImage
                
                UINavigationController?.pushViewController(editPhotoViewController, animated: false)
            }
        }
        
        
    
       
        
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let focusingOn = touches.first, let device = captureDevice {
            
            if device.isFocusPointOfInterestSupported {
                
                let focusPoint = touchPercent(touch: focusingOn)
                
                do {
                    try device.lockForConfiguration()
                    
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                    
                } catch {
                    fatalError()
                }
            }
        }
    }
    
    // 화면 밝기
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
   func touchPercent(touch focusingOn: UITouch) -> CGPoint {
        
        //카메라 스케일(해상도)
        
        let cameraSize = cameraView.bounds.size
        
        // 0~1.0 으로 x, y 화면대비 비율 구하기
        let x = focusingOn.location(in: cameraView).y / cameraSize.height
        let y = 1.0 - focusingOn.location(in: cameraView).x / cameraSize.width
        let ratioOfPoint = CGPoint(x: x, y: y)
        
        return ratioOfPoint
    }
    
    
    
}
    //apple developer의 AVCaptureDevice.FlashMode문서를 참조해 extension추가 및 method 구현
    // https://developer.apple.com/documentation/avfoundation/avcapturedevice/flashmode

// MARK:- Flash Mode
    
