//
//  ZLAlbumListController.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import Photos

class ZLAlbumListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var navView = ZLExternalAlbumListNavView(title: localLanguageTextValue(.photo))
    
    var navBlurView: UIVisualEffectView?
    
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    var arrDataSource: [ZLAlbumListModel] = []
    
    var shouldReloadAlbumList = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ZLPhotoConfiguration.default().statusBarStyle
    }
    
    deinit {
        zl_debugPrint("ZLAlbumListController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        guard shouldReloadAlbumList else {
            return
        }
        
        DispatchQueue.global().async {
            ZLPhotoManager.getPhotoAlbumList(ascending: ZLPhotoConfiguration.default().sortAscending, allowSelectImage: ZLPhotoConfiguration.default().allowSelectImage, allowSelectVideo: ZLPhotoConfiguration.default().allowSelectVideo) { [weak self] (albumList) in
                self?.arrDataSource.removeAll()
                self?.arrDataSource.append(contentsOf: albumList)
                
                self?.shouldReloadAlbumList = false
                ZLMainAsync {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navViewNormalH: CGFloat = 44
        
        var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        var collectionViewInsetTop: CGFloat = 20
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
            collectionViewInsetTop = navViewNormalH
        } else {
            collectionViewInsetTop += navViewNormalH
        }
        
        navView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: insets.top + navViewNormalH)
        
        tableView.frame = CGRect(x: insets.left, y: 0, width: view.frame.width - insets.left - insets.right, height: view.frame.height)
        tableView.contentInset = UIEdgeInsets(top: collectionViewInsetTop, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }
    
    func setupUI() {
        view.backgroundColor = .albumListBgColor
        
        tableView.backgroundColor = .albumListBgColor
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 65
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        tableView.separatorColor = .separatorLineColor
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        ZLAlbumListCell.zl_register(self.tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .always
        }
        
        navView.backBtn.isHidden = true
        navView.cancelBlock = { [weak self] in
            let nav = self?.navigationController as? ZLImageNavController
            nav?.cancelBlock?()
            nav?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(navView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZLAlbumListCell.zl_identifier(), for: indexPath) as! ZLAlbumListCell
        
        cell.configureCell(model: arrDataSource[indexPath.row], style: .externalAlbumList)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZLThumbnailViewController(albumList: arrDataSource[indexPath.row])
        show(vc, sender: nil)
    }

}


extension ZLAlbumListController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        shouldReloadAlbumList = true
    }
    
}

