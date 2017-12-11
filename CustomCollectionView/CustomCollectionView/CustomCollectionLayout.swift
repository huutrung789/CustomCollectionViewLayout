//
//  CustomCollectionLayout.swift
//  CustomCollectionView
//
//  Created by HuuTrung on 12/11/17.
//  Copyright © 2017 HuuTrung. All rights reserved.
//

import UIKit

protocol CustomCollectionLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
}

class CustomCollectionLayout: UICollectionViewLayout {
    weak var delegate: CustomCollectionLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 5
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard cache.isEmpty == true, let _ = collectionView else {
            return
        }
        
        //add attribute into cache array
        
        //Calculate xOffset, yOffset
        let columnWidth = contentWidth/CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column)*columnWidth)
        }
        //Init yOffset array: [0,0,...] (depend on number of Columns)
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var column = 0
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            
            //Calculate frame for each item
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath)
            let height = photoHeight + cellPadding*2
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribues = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribues.frame = insetFrame
            
            cache.append(attribues)
            
            //calculate Y offset for the next element and add to offsetY array
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            //Increase column = numberOfColumns
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //        print("layoutAttributesForElements")
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //        print("layoutAttributesForItem")
        return cache[indexPath.item]
    }
}

