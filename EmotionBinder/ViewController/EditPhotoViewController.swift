//
//  EditPhotoViewController.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 05/08/2019.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit
import Photos

class EditPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var imagefilterCollectionView: UICollectionView!
    @IBOutlet weak var photogarghedImage: UIImageView!
    
    var takenPhotoImage: UIImage? //촬영 원본
    var takenResizedPhotoImage: UIImage? //촬영 후 리사이즈된 이미지
    var imageTapStatus: Bool? //이미지 선택(탭) 상태 확인 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swift 4에서 문법 변경으로 뒤에 캐스팅
        //UICollectionViewDlelgate, UICollectionViewDatasource setting
        imagefilterCollectionView.delegate = self as UICollectionViewDelegate
        imagefilterCollectionView.dataSource = self as UICollectionViewDataSource
        photogarghedImage.image = takenPhotoImage
        
        imageTapStatus = false // 이미지 선택되지 않은 상태로 초기값 셋팅

        photogarghedImage.isUserInteractionEnabled = true
        //Tap Gesture 설정. 기본값이 false
        
        let photographedImageGestureRecogninzer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggledImage))
        photogarghedImage.addGestureRecognizer(photographedImageGestureRecogninzer)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillAppear in EditPhotoViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear in EditPhotoViewController")
        
        self.imagefilterCollectionView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .bottom)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewWillDisappear in EditPhotoViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidDisappear in EditPhotoViewController")
    }
    
    @objc func toggledImage(sender: UITapGestureRecognizer) {
        print("1")
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


extension EditPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate static let cameraFilterCollectionViewCellIdentifier: String = "FilterCell"
    
    struct PhotoEditorTypes {
        
        static let titles: [String?] = ["Filter"]
        static let rowTitles: [[String?]?] = [["Normal", "Mono", "Tonal", "Noir", "chrome", "Process", "Transfer", "Instant"]]
        
        static func RowNumbers(of select: Int) -> Int {
            
            
            return rowTitles[section]?.count ?? 0
            
        }
        
        static func titleForIndexPath(_ indexPath: IndexPath) -> String? {
            return rowTitles[indexPath.section]?[indexPath.row]
        }
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemInSection")
        
        return PhotoEditorTypes.RowNumbers(of: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPhotoViewController.cameraFilterCollectionViewCellIdentifier, for: indexPath) as! FilterCollectionViewCell
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections")
        
        return PhotoEditorTypes.titles.count
    }
    
    //filter cell 선택시 호출 되는 메소드
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell { selectedCell.isSelected =  true}
        
        //선택 셀 정렬(수평 중간)메소드
        self.imagefilterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //cell 선택 해제시 호출
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            
            deselectedCell.isSelected = false
        }
    }
    
}

extension EditPhotoViewController {
    
    func imageForFullView(sender: UITapGestureRecognizer){
        if let status = imageTapStatus {
            
            let tap = sender.tapStatus(status)
            switch tap {
            case true:
                self.imageTapStatus = tap
                changeUIToState(true)
            case false:
                self.imageTapStatus = tap
                changeUIToState(false)
            }
        }
    }
    
    func changeUIToState(_ tap: Bool){
        
        //NavigationBar와 하단의 CollectionView를 표시/숨김
        if tap {
            navigationController?.isNavigationBarHidden = true
            imagefilterCollectionView.isHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            imagefilterCollectionView.isHidden = false
        }
    }
}
