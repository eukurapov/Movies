//
//  ViewController.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    var collections = [Collection]()
    
    private lazy var collectionsView: UICollectionView = {
        let collectionLayout = createLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.identifier)
        collectionView.register(MovieListItemCell.self, forCellWithReuseIdentifier: MovieListItemCell.identifier)
        collectionView.register(MovieThumbnailCell.self, forCellWithReuseIdentifier: MovieThumbnailCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: SectionHeader.kind, withReuseIdentifier: SectionHeader.identifier)
        return collectionView
    }()

    private var animationController = ZoomInAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mövies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.movieText]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.movieText]
        navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = .movieDarkPurple
        
        MovieService.shared.fetchCellections() { [weak self] result in
            switch result {
            case .success(let newCollection):
                self?.collections = newCollection
                self?.collectionsView.reloadData()
            case .failure(let error):
                self?.collections = MockData.collections
                print(error)
            }
        }
        
        layout()
    }
    
    private func layout() {
        view.addSubview(collectionsView)
        NSLayoutConstraint.activate([
            collectionsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}

extension CollectionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = collections[indexPath.section].movies[indexPath.row]
        let vc = DetailsViewController()
        vc.movie = movie
        vc.view.layoutIfNeeded()
        vc.modalPresentationStyle = .overFullScreen
        vc.transitioningDelegate = self
        present(vc, animated: true)
    }
    
}

extension CollectionsViewController: UICollectionViewDataSource {
    
    private func cellTypeIndexForSection(_ sectionIndex: Int) -> Int {
        return sectionIndex % 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellTypeIndex = cellTypeIndexForSection(indexPath.section)
        if cellTypeIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.identifier, for: indexPath)
            if let card = cell as? MovieCardCell {
                card.movie = collections[indexPath.section].movies[indexPath.item]
            }
            return cell
        } else if cellTypeIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieThumbnailCell.identifier, for: indexPath)
            if let thumbnail = cell as? MovieThumbnailCell {
                thumbnail.movie = collections[indexPath.section].movies[indexPath.item]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListItemCell.identifier, for: indexPath)
            if let listItem = cell as? MovieListItemCell {
                listItem.movie = collections[indexPath.section].movies[indexPath.item]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath)
        if let header = view as? SectionHeader {
            header.text = collections[indexPath.section].name
            if cellTypeIndexForSection(indexPath.section) == 1 {
                header.textStyle = .body
            }
        }
        return view
    }
    
}

private extension CollectionsViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let section: NSCollectionLayoutSection
            
            switch self.cellTypeIndexForSection(sectionIndex) {
            case 0: section = self.horisontalCardsSection(layoutEnvironment: layoutEnvironment)
            case 1: section = self.horisontalThumnailSection(layoutEnvironment: layoutEnvironment)
            default: section = self.tableViewSection(layoutEnvironment: layoutEnvironment)
            }
            return section
        }
        return layout
    }
    
    func horisontalCardsSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = layoutEnvironment.container.contentSize.width * 0.85
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth),
                                               heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        
        return section
    }
    
    func horisontalThumnailSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(20))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: SectionHeader.kind,
            alignment: .top)
        section.boundarySupplementaryItems = [titleSupplementary]
        
        return section
    }
    
    func tableViewSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(20))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: SectionHeader.kind,
            alignment: .top)
        section.boundarySupplementaryItems = [titleSupplementary]
        
        return section
    }
    
}

extension CollectionsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPath = collectionsView.indexPathsForSelectedItems?[0],
              let view = collectionsView.cellForItem(at: indexPath)
        else { return nil }
        
        guard let details = presented as? DetailsViewController else { return nil }
        
        let cellImageView: UIImageView
        switch view {
        case let item as MovieListItemCell: cellImageView = item.imageView
        case let card as MovieCardCell: cellImageView = card.imageView
        default: return nil
        }
        
        animationController.originFrame = view.convert(cellImageView.frame, to: nil)
        animationController.transitionFrame = details.view.convert(details.imageView.frame, to: nil)
        
        animationController.presenting = true
        view.contentView.alpha = 0
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPath = collectionsView.indexPathsForSelectedItems?[0],
              let view = collectionsView.cellForItem(at: indexPath)
        else { return nil }
        guard !(view is MovieThumbnailCell) else { return nil }
        animationController.onDismiss = {
            view.contentView.alpha = 1
        }
        animationController.presenting = false
        return animationController
    }
    
}
