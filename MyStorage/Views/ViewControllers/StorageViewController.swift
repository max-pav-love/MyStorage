//
//  StorageViewController.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 23.08.2022.
//

import UIKit
import FirebaseStorage
import FirebaseCore

final class StorageViewController: UIViewController, AlertPresentableView {
    
    // MARK: - Properties
    
    var viewModel: StorageViewModel

    private weak var coordinator: AppCoordinator?
        
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            FileCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: FileCollectionViewCell.self)
        )
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var firstUsageLabel: UILabel = {
       let label = UILabel()
        label.text = "Add files by clicking +"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Init
    
    init(coordinator: AppCoordinator, viewModel: StorageViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupConstraints()
        bindViewModel()
        bindToAlerts()
        setupActivityIndicator()
        setupTitle()
        viewModel.getData()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        let uploadBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showUploadAlert)
        )
        let addFolderBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addFolderButtonTapped(_:))
        )
        let changeLayoutModeBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet.rectangle"),
            style: .plain,
            target: self,
            action: #selector(changeLayoutModeButtonTapped(_:))
        )
        navigationItem.rightBarButtonItems = [uploadBarButtonItem, addFolderBarButtonItem]
        navigationItem.leftBarButtonItem = changeLayoutModeBarButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupTitle() {
        let lastPath = viewModel.path?.split(separator: "/").last
        title = String(lastPath ?? "Storage")
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 8,
            right: 0
        )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
    
    private func bindViewModel() {
        viewModel.documents.bind { [weak self] files in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.activityIndicator.removeFromSuperview()
                self?.firstUsageLabel.isHidden = !files.isEmpty
            }
        }
        viewModel.layoutMode.bind{ [weak self] mode in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc
    private func showUploadAlert() {
        showUploadAlertFor(folder: nil)
    }
    
    private func showUploadAlertFor(folder: String?) {
        let alert = UIAlertController(
            title: "Upload:",
            message: nil,
            preferredStyle: .actionSheet
        )
        let imagePickerAction = UIAlertAction(
            title: "From gallery",
            style: .default
        ) { _ in
            self.viewModel.setupPicker(folder: folder)
            self.viewModel.itemPicker?.presentImagePicker(from: self)
        }
        let documentPickerAction = UIAlertAction(
            title: "File",
            style: .default
        ) { _ in
            self.viewModel.setupPicker(folder: folder)
            self.viewModel.itemPicker?.presentDocumentPicker(from: self)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alert.addAction(imagePickerAction)
        alert.addAction(documentPickerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func addFolderButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Create a folder",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Enter folder name"
        }
        
        let createAction = UIAlertAction(
            title: "Create",
            style: .default
        ) { [weak self] _ in
            if let folderName = alert.textFields?[0].text {
                self?.showUploadAlertFor(folder: folderName)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
    
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func changeLayoutModeButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.changeLayout()
    }
    
    private func handleDownloadTap(file: File) {
        viewModel.download(url: file.path.encodeToURL())
    }
    
    //There is no public API to rename file
    
    private func handleRenameTap() {
        let alert = UIAlertController(
            title: "You can't do it",
            message: "There is no public API to rename file",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func handleDeleteTap(file: File) {
        viewModel.delete(url: file.path.encodeToURL())
    }

    
    private func createContextMenu(for indexPath: IndexPath) -> UIMenu? {
        let menuBuilder = UIContextMenuBuilder()
        let file = viewModel.documents.value[indexPath.item]
        
        if !file.isDirectory{
            menuBuilder.downloadHandler = { [weak self] _ in
                self?.handleDownloadTap(file: file)
            }
            menuBuilder.renameHandler = { [weak self] _ in
                self?.handleRenameTap()
            }
            menuBuilder.deleteHandler = { [weak self] _ in
                self?.handleDeleteTap(file: file)
            }
            return menuBuilder.build()
        } else {
            return nil
        }
        
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.addSubview(firstUsageLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            firstUsageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            firstUsageLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FileCollectionViewCell.self),
            for: indexPath
        ) as? FileCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let file = viewModel.documents.value[indexPath.item]
        let layoutMode = viewModel.layoutMode.value
        cell.configureCellWith(file.name, file.type, layoutMode: layoutMode)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.documents.value.count
    }

}

// MARK: - UICollectionViewDelegate

extension StorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.documents.value[indexPath.item]
        if item.isDirectory {
            coordinator?.showStorageScreen(path: item.path)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = indexPath as NSCopying
        let configurator = UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil
        ) { [weak self] _ in
            return self?.createContextMenu(for: indexPath)
        }
        return configurator
    }
    
}

extension StorageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.layoutMode.value {
        case .grid:
            let width = view.bounds.width / 4
            let height = view.bounds.height / 8
            return CGSize(width: width, height: height)
        case .list:
            let width = view.bounds.width
            let height = view.bounds.height / 14
            return CGSize(width: width, height: height)
        }
    }
    
}
