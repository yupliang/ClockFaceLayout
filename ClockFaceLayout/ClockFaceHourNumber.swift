//
//  ClockFaceHourNumber.swift
//  ClockFaceLayout
//
//  Created by app-01 on 2020/3/18.
//

import UIKit

public class ClockFaceHourNumber: UICollectionViewLayout {
    var attributesArray = [UICollectionViewLayoutAttributes]()
    open var hourLabelCellSize:CGSize!
    var clockRadius: CGFloat!
    var cvCenter:CGPoint!
    
    override public func prepare() {
        clockRadius = collectionView!.frame.size.width / 2 - hourLabelCellSize.width / 2 - 10
        print("ClockFaceHourNumber \(clockRadius ?? 0)")
        cvCenter = CGPoint(x: collectionView!.frame.size.width/2, y: collectionView!.frame.size.height/2)
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.size = hourLabelCellSize
                let angularDisplacement:Double = (Double.pi * 2) / 12
                let theta = angularDisplacement *  Double( indexPath.row)
                let xDisplacement = cos(theta) * Double(clockRadius)
                let yDisplacement = sin(theta) * Double(clockRadius)
                let xPosition = cvCenter.x + CGFloat(xDisplacement)
                let yPosition = cvCenter.y - CGFloat(yDisplacement)
                let center:CGPoint = CGPoint(x: xPosition, y: yPosition)
                attr.center = center
                attributesArray.append(attr)
            }
        }
    }
    override public var collectionViewContentSize: CGSize {
        return collectionView!.frame.size
    }
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray.filter { (attrs) -> Bool in
            attrs.indexPath == indexPath
        }.first
    }
}
