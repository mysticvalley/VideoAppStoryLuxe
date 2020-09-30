//
//  FrameListingViewController.swift
//  VideoApp
//
//  Created by VideoApp on 14/02/2019.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit
import PopupDialog

class FrameListingViewController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var frameSeriesData: FrameSeriesData
    var frameModel: FrameModel
    var frameIconContainer: FrameIconContainer
    
    var isFirstLaunch = false

    var segment = 1

    var expiryHandler: ((UIViewController) -> Void)?
    var gracePeriodHandler: ((UIViewController) -> Void)?
    
    required init?(coder: NSCoder) {
        self.frameSeriesData = FrameSeriesData(segment: segment)
        self.frameModel = frameSeriesData.frameModel
        self.frameIconContainer = FrameIconContainer()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavColors()
        setupFrameIconContainer()
        setupFrameIconButton()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = false
    }
    
    func setUpNavColors() {
        let top = self.view.getViewWithTag(99)
        let bottom = self.view.getViewWithTag(100)
        top.backgroundColor = AppUtils.shared.MY_GREY
        bottom.backgroundColor = AppUtils.shared.MY_GREY
        self.view.backgroundColor =  AppUtils.shared.MY_GREY
    }
    
    func setupFrameIconContainer() {
        view.addSubview(frameIconContainer)
        NSLayoutConstraint.activate([
            frameIconContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameIconContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameIconContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            frameIconContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupFrameIconButton() {
        let frameIconViews = frameIconContainer.containerView.subviews
        for (index, subview) in frameIconViews.enumerated() {
            let frameIconView = subview as! FrameIconView
            frameIconView.button.setAction { [weak self] in
                guard let self = self else { return }
                self.reset()
                self.segment = index + 1
                self.frameModel = FrameSeriesData(segment: self.segment).frameModel
                self.animateCollectionView(and: frameIconView)
            }
        }
    }
    
    func reset() {
        let frameIconView = frameIconContainer.frameIconViews[segment - 1]
        frameIconView.isUserInteractionEnabled = true
        frameIconView.centerYConstraint?.constant = 0

        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateCollectionView(and frameIconView: FrameIconView) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        
        frameIconView.isUserInteractionEnabled = false
        frameIconView.centerYConstraint?.constant = -5

        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.collectionView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.collectionView.reloadData()
                self.collectionView.transform = CGAffineTransform.identity
            }
        })
    }
    
    // MARK: - Button Actions
    @IBAction func MenuAct(_ sender: UIButton) {
    }
    
}

//MARK: - Collection View Delegate and Datasource
extension FrameListingViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .white
        cell.label.text = "frame \(segment)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  20
        let cellWidth = ( collectionView.frame.size.width - padding ) / 2
        //maintain aspect ratio
        let cellHeight = cellWidth / 9.0 * 16.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let board = UIStoryboard(name: frameModel.name, bundle: nil)
        let array = ["Frame1", "Frame2"]
        let identifier = array[segment - 1]
        let vc = board.instantiateViewController(withIdentifier: identifier) as! EditViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
