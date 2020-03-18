//
//  PinterestLayout.swift
//  SongSet
//
//  Created by app-01 on 2020/3/18.
//  Copyright © 2020 ToolMaker. All rights reserved.
//

import UIKit

public protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

public class PinterestLayout: UICollectionViewLayout {
    
    public weak var delegate: PinterestLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var cache: [UICollectionViewLayoutAttributes] = []
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    public override func prepare() {
        guard let collectionView = collectionView else { return  }
        
        var xOffset: [CGFloat] = []
        let columnWidth = contentWidth / CGFloat( numberOfColumns)
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column)*columnWidth)
        }
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: photoHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            attrs.frame = insetFrame
            cache.append(attrs)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + photoHeight
            
            column = column < (numberOfColumns - 1) ? column + 1 : 0
        }
    }
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attr in cache {
            if attr.frame.intersects(rect) {
                visibleLayoutAttributes.append(attr)
            }
        }
        return visibleLayoutAttributes
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
