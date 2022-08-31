//
//  SectionDecorationViewController.swift
//  iOSTrainning
//
//  Created by justin on 2022/8/31.
//

import UIKit

class SectionDecorationViewController: UIViewController {

    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Section Background Decoration View"
        configureHierarchy()
        configureDataSource()
    }
}

extension SectionDecorationViewController {
    /// - Tag: Background
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension SectionDecorationViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<ListCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            let sectionIdentifier = self.currentSnapshot.sectionIdentifiers[indexPath.section]
            let numberOfItemsInSection = self.currentSnapshot.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numberOfItemsInSection
            cell.label.text = "\(indexPath.section),\(indexPath.item)"
            cell.seperatorView.isHidden = isLastCell
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            currentSnapshot.appendSections([$0])
            currentSnapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension SectionDecorationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

