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
            
            return 0 //임시 반환
            // return rowTitles[Section]?.count ?? 0
            // syntax 주석처리
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
}
