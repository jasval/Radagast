//
//  ShadowedCollectionCell.swift
//  Radagast
//
//  Created by Jasper Valdivia on 10/04/2021.
//

import UIKit

protocol ShadowedCollectionCell: UICollectionViewCell {
    var shadowLayer: ShadowView { get set }
}
