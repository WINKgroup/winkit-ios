//
//  RxSwift.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 10/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import RxSwift

extension Variable: CustomStringConvertible {
    public var description: String { return "\(value)" }
}

public extension Reactive where Base : UITableView {
    
    public func items<S: Sequence, VM: WKViewModel, Cell: WKTableViewCell<VM>, O : ObservableType>
        (cellType: Cell.Type = Cell.self, vmType: VM.Type = VM.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S {
            return items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
    }

}

public extension Reactive where Base : UICollectionView {
    
    public func items<S: Sequence, VM: WKViewModel, Cell: WKCollectionViewCell<VM>, O : ObservableType>
        (cellType: Cell.Type = Cell.self, vmType: VM.Type = VM.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S {
            return items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
    }
    
}
