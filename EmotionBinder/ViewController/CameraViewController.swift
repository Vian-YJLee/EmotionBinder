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

@available(iOS 10.2, *)
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
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
    
    
    var focusBox: UIView!
    var emojiFaceIcon: UIImageView?
    var isAddFunEmoticon: Bool?
    var originalImage: UIImage?
    
    var filterTitle: String? //필터 이름 지정
    var filterIndex: Int? // 현재 필터를 저장해둘 인덱스 변수. 스와이프 기능으로 동작할 때 사용
    var cameraPosition: AVCaptureDevice.Position?
    var flashSwitchStatus: Int = 0 // 플래시 모드(항상끔 켬 등..)의 상태 저장하는 프로퍼티
    //온오프 구분을 위해 extension으로 프로토콜을 추가해 conformance하도록 구성
    
    var screenRatioStatus: Int = 0 // 화면 비율조정 상태 저장 프로퍼티
    var previewImage: CGRect?
    
      //developer.apple.com의 AVFoundation 문서 참조
    
    var captureSession: AVCaptureSession?
    // 비디오 장치로부터 데이터 출력의 흐름 조정하는 AVCaptureSession 객체
    var sessionOutput = AVCapturePhotoOutput()
    // 스틸 이미지(사진)와 관련해 최신 캡쳐 인터페이스 워크 플로우를 제공하는 AVCaptureOutput의 하위클래스. 카메라 화질, 저장방식, Flash 사용 유무 여부 등을 제어함
    var previewLayer = AVCaptureVideoPreviewLayer() // CALayer의 서브클래스. 입력장치로부터 캡쳐된 비디오를 표시하는데 사용
    var captureSetting = AVCapturePhotoSettings()
    //이미지 촬영(캡쳐)시 사용될 동작(플래시 발광 등)과 사진 저장에 필요한 각종 이미지 데이터(저장할 이미지 해상도, 화질 등등) 셋팅값들을 제어하는 클래스
    var cameraView: UIView!
    
    var protection: String?
    
    //상태 바 숨김
    var isHidden: Bool = true{
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    //MAKR: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession = AVCaptureSession()
    
        if let session = captureSession {
            
            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            
            //참조 https://developer.apple.com/documentation/avfoundation/avcapturesession/preset
            
            let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera, AVCaptureDevice.DeviceType.builtInDualCamera],  mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            
            // AVCaptureDevice.DeviceType.builtInDualCamera 는 iOS 10.2 이상에서만 작동.
            // @avilable 붙여 구동 전 기기 확인
            
            if let session = captureSession {
                for discoveredDevice in (deviceSession.devices) {
                    
                    if discoveredDevice.position == AVCaptureDevice.Position.back {
                        do {
                            let input = try AVCaptureDeviceInput(device: discoveredDevice)
                            if session.canAddInput(input){
                                session.addInput(input)
                            
                                if session.canAddOutput(sessionOutput){
                                    session.addOutput(sessionOutput)
                                    
                                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill //화면조정방식 변경 resize -> resizeAspectFill
                                    previewLayer.connection?.videoOrientation = .portrait
                                    
                                    cameraView.layer.addSublayer(previewLayer)
                                    
                                    previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                                    
                                    previewLayer.frame = cameraView.bounds
                                    
                                    let previewLayerHeight = previewLayer.bounds.height
                                    let cameraViewLayoutHeight = cameraView.bounds.height
                                    
                                    
                                    print("PreviewLayoutHeight: \(previewLayerHeight)")
                                    print("cameraViewLayoutHeght: \(cameraViewLayoutHeight)")
                                    
                                    session.stopRunning()
                                }
                            }
                        } catch let avCaptureError {
                            print(avCaptureError)
                        }
                    }
                } //기기 상태 확인 끝
            
          /*  if #available(iOS 10.2, *) {
                let devicesession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera, AVCaptureDevice.DeviceType.builtInDualCamera],  mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            } else {
                // Fallback on earlier versions
            }
        } */
            }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //캡쳐
    
    @IBAction func takePhoto(_ sender: Any) {
        
        let settingForMonitoring = AVCapturePhotoSettings()
        
        settingForMonitoring.flashMode = .auto
        settingForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingForMonitoring.isHighResolutionPhotoEnabled = false
        
        
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
    //카메라 취소
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
            var newCameraInput:AVCaptureDevice! = nil
            
            //사이즈 설정 참조 https://developer.apple.com/documentation/avfoundation/avcapturesession/preset

            if let input = presentCameraInput as? AVCaptureDeviceInput {
                if(input.device.position == .back) {
                    newCameraInput = cameraSwichingPosition(position: .front)
                    session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                }else if(input.device.position == .front) {
                    
                    newCameraInput = cameraSwichingPosition(position: .back)
                    session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                
                }
            }
            
            //Add input to session
            
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCameraInput)
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
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
@available(iOS 10.2, *)
func cameraSwichingPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let deviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera, AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in (deviceSession.devices) {
            return device
        }
    return nil
    }

func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer PhotoSampleBuffer: CMSampleBuffer?, previewPhtoSampleBuffer: CMSampleBuffer?, resolvedsettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCapturePhotoBracketSettings?, error: Error?) {
    
    if let photoSampleBuffer = PhotoSampleBuffer {
        let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: PhotoSampleBuffer!, previewPhotoSampleBuffer: previewPhtoSampleBuffer)
        let takedPhotoImage = UIImage(data: photoData!)
     
       
        if let image = takedPhotoImage {
            UIImageWriteToSavedPhotosAlbum(image, Any?.self, #selector(saveCompleted), nil)
        } */
    }
    
    
}

func saveCompleted(_ image: UIImage, didFinishSaveingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
    dump(image)
    
    let resizedImage = image.resizeImage(targetSize: CGSize(width: 64, height: 64))
    
    lf let editPhotoViewController = storyboard?.instantiataViewContreoller(withIdentifier: storiboardIdentifierConstantOfeditPhotoViewController) as? EditPhotoViewController {
        
        editPhotoViewController.takenPhotoImge = image
        
    }
}


//apple developer의 AVCaptureDevice.FlashMode문서를 참조해 extension추가 및 method 구현
// https://developer.apple.com/documentation/avfoundation/avcapturedevice/flashmode

@available(iOS 10.2, *)
extension CameraViewController {
    
    enum FlashModeCheck: Int {
        case off = 0
        case on
        case auto
        //열거형으로 상태 검증..
    }
    
    func getFlashModeConstants(_ mode: Int) -> AVCaptureDevice.FlashMode {
        // Objective-C 문법..애플 개발자 문서 상세 참조...
        
        var valueOfFlashMode: AVCaptureDevice.FlashMode = .off
        
        
        switch mode {
        case FlashModeCheck.off.rawValue: valueOfFlashMode = .off
        case FlashModeCheck.auto.rawValue: valueOfFlashMode = .auto
        case FlashModeCheck.on.rawValue: valueOfFlashMode = .on
        
        default:
            break;
        }
        
        return valueOfFlashMode
    }
}



