import UIKit
import Photos

final class GalleryTestViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let manager = PhotoManager()
    private var columns = 3 {
        didSet {
            collectionView.collectionViewLayout = createLayout()
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        Task {
            let granted = await manager.requestPermission()
            
            if granted {
                collectionView.reloadData()
            }
        }
    
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GaleryTestViewCell.self, forCellWithReuseIdentifier: GaleryTestViewCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinchGesture)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 2
        let layout = UICollectionViewFlowLayout()
        let totalSpacing = spacing * CGFloat(columns - 1)
        let width = (view.bounds.width - totalSpacing) / CGFloat(columns)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = .zero
        return layout
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .ended {
            if gesture.scale > 1.1 {
                columns = max(columns - 1, 1)
            } else if gesture.scale < 0.9 {
                columns = min(columns + 1, 6)
            }
        }
    }
}

extension GalleryTestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GaleryTestViewCell.reuseIdentifier, for: indexPath) as? GaleryTestViewCell else {
            return UICollectionViewCell()
        }
        
        let asset = manager.assets[indexPath.item]
        cell.configure(with: asset, manager: manager, columns: columns)
        return cell
    }
}
