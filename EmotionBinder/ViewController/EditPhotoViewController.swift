//
//  EditPhotoViewController.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 05/08/2019.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {
    
    let cameraFilterCollectionViewCellIdentifier: String = "FilterCell"
    
    struct PhotoEditorTypes {
        
        static let titles: [String?] = ["Filter"]
        static let rowTitles: [[String?]?] = [["Normal", "Mono", "Tonal", "Noir", "chrome", "Process", "Transfer", "Instant"]]
        
        static func RowNumbers(of select: Int) -> Int {
            
            
            return rowTitles[Section]?.count ?? 0
            
        }
        
        static func titleForIndexPath(_ indexPath: IndexPath) -> String? {
            return rowTitles[indexPath.section]?[indexPath.row]
        }
        
    }
    @IBOutlet weak var imagefilterCollectionView: UICollectionView!
    @IBOutlet weak var photogarghedImage: UIImageView!
    
    var takenPhotoImage: UIImage?
    var takenResizedPhotoImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagefilterCollectionView.delegate = self as UICollectionViewDelegate
        imagefilterCollectionView.dataSource = self as UICollectionViewDataSource
        photogarghedImage.image = takenPhotoImage

        // Do any additional setup after loading the view.
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
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemInSection")
        
        return PhotoEditorTypes.RowNumbers(of: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cameraFilterCollectionViewCellIdentifier, for: indexPath) as! FilterCollectionViewController
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections")
        
        return PhotoEditorTypes.titles.count
    }
    
    //filter cell 선택시 호출 되는 메소드
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCell = UICollectionViewCell.cellForItem(at: indexPath) as? FilterCollectionViewCell { selectedCell.isSelected =  true}
        
        //선택 셀 정렬(수평 중간)메소드
        self.imagefilterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //cell 선택 해제시 호출
    
    private func collectionView(_ collectionView: UICollectionViewCell, didDeselectItemAt indexPath: IndexPath) {
        
        if let deselectedCell = collectionViewCell.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            deselectedCell.isSelected = false
        }
    }
    
}
