//
//  ClockLayout.swift
//  SongSet
//
//  Created by app-01 on 2020/3/16.
//  Copyright © 2020 ToolMaker. All rights reserved.
//

import UIKit

public class ClockLayout: UICollectionViewLayout {
    var attributesArray = [UICollectionViewLayoutAttributes]()
    var cvCenter: CGPoint!
    let dateFormatter = DateFormatter()
    var clockTime: NSDate!
    var timeHousrs: Int!
    var timeSeconds: Int!
    open var secondHandSize: CGSize!
    
    override public func prepare() {
        cvCenter = CGPoint(x: collectionView!.frame.size.width/2, y: collectionView!.frame.size.height/2)
        let rotationPerMinute: Double = (2 * Double.pi) / 60.0
        
        clockTime = NSDate()
        
        dateFormatter.dateFormat = "HH"
        let hourString = dateFormatter.string(from: clockTime as Date)
        timeHousrs = Int(hourString)
        
        dateFormatter.dateFormat = "ss"
        let secondString = dateFormatter.string(from: clockTime as Date)
        timeSeconds = Int(secondString)
        print("prepare hour \(timeHousrs ?? 0):00:\(timeSeconds ?? 0)")
        
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let newAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if let matchingAttributeIndex = attributesArray.firstIndex(where: { (oneAttris) -> Bool in
                    oneAttris.indexPath.compare(newAttributes.indexPath) == ComparisonResult.orderedSame
                }) {
                    attributesArray[matchingAttributeIndex] = newAttributes
                } else {
                    attributesArray.append(newAttributes)
                }
                newAttributes.size = secondHandSize
                newAttributes.center = cvCenter
                let angularDisplacement = rotationPerMinute * Double(timeSeconds+indexPath.item*2)
                newAttributes.transform = CGAffineTransform(rotationAngle: CGFloat(angularDisplacement))
            }
        }
        print("layout coutn \(attributesArray.count)\n")
    }
    
    override public var collectionViewContentSize: CGSize {
        var numbers = 0
        for section in 0..<collectionView!.numberOfSections {
            numbers += collectionView!.numberOfItems(inSection: section)
        }
        print("collectionViewContentSize numbers \(numbers)")
        return CGSize(width: collectionView!.frame.size.width, height: max(collectionView!.frame.height, CGFloat(50+110*numbers)))
    }
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray.filter { (theAttrubute) -> Bool in
            theAttrubute.indexPath == indexPath
        }.first
    }
    
}
