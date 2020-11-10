//
//  ViewController.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    var collections: [Collection] {
        MockData.collections
    }
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mövies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.backgroundColor = .movieDarkPurple
        
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

extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.identifier, for: indexPath)
            if let card = cell as? MovieCardCell {
                card.movie = collections[indexPath.section].movies[indexPath.item]
            }
            return cell
        } else if indexPath.section == 1 {
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
            if indexPath.section == 1 {
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
            
            switch sectionIndex {
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
