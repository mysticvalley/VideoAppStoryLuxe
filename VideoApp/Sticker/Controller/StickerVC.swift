//
//  StickerVC.swift
//  VideoApp
//
//  Created by Lauren on 3/7/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

protocol StickerViewDelegate: class {
    func addSticker(stickerImage : UIImage)
}

class StickerVC: UIViewController {
    
    weak var delegate: StickerViewDelegate?
    
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var stickerScrollView: UIScrollView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var safeSpaceFillView: UIView!
    
    @IBOutlet var stickerCollectionViews: [UICollectionView]! {
        didSet {
            stickerCollectionViews.sort { $0.tag < $1.tag }
        }
    }
    
    @IBOutlet var tabButtons: [UIButton]! {
        didSet {
            tabButtons.sort { $0.tag < $1.tag }
        }
    }
    
    private let CELL_REUSE_IDENTIFIER = "StickerCell"

    private let stickerPackData = StickerPackData()

    private var initialPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()

        for collectionView in stickerCollectionViews {
            collectionView.delegate = self
            collectionView.dataSource = self
        }

        let bottomBarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBottomBarTap(_:)))
        bottomBarView.addGestureRecognizer(bottomBarTapGestureRecognizer)
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Handle Purchase Notification
    @objc func handleUiUpdate(_ notification: Notification) {
        reloadCollectionViews()
    }
    
    func reloadCollectionViews() {
        DispatchQueue.main.async {
            self.stickerCollectionViews.forEach { $0.reloadData() }
        }
    }
    
    //MARK: - Layout Functions
    func layout() {
        layoutMainContainer()
    }
    
    func layoutMainContainer() {
        mainContainer.clipsToBounds = true
        mainContainer.layer.cornerRadius = 10
        mainContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc func dismissStickerView() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIGestureRecognizer extension
extension StickerVC: UIGestureRecognizerDelegate {
    @objc func handleBottomBarTap(_ gesture: UITapGestureRecognizer) {
        dismissStickerView()
    }
}

// MARK: - UICollectionView extensions
extension StickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let categoryIndex = stickerCollectionViews.firstIndex(of: collectionView) {
            return stickerPackData.getNumberOfStickerPacks(for: categoryIndex)
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categoryIndex = stickerCollectionViews.firstIndex(of: collectionView) {
            return stickerPackData.getStickerPackModel(for: categoryIndex, packIndex: section).count
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryIndex = stickerCollectionViews.firstIndex(of: collectionView) else {
            fatalError()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_REUSE_IDENTIFIER, for: indexPath) as! StickerCell

        let stickerArray = stickerPackData.getStickers(for: categoryIndex)
        cell.stickerImageView.image = stickerArray[indexPath.section][indexPath.item]
        cell.stickerImageView.contentMode = .scaleAspectFit
        
        return cell
    }

    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: IAP Stuff
        guard let categoryIndex = stickerCollectionViews.firstIndex(of: collectionView) else { fatalError("Invalid collection view index for cell.") }
        let stickerArray = stickerPackData.getStickers(for: categoryIndex)
        delegate?.addSticker(stickerImage: stickerArray[indexPath.section][indexPath.item])
        dismissStickerView()
    }
}
