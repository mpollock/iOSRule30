//
//  AutomatonCollectionViewController.swift
//  rule30Automaton
//
//  Created by Michael P on 1/22/21.
//

import UIKit

final class AutomatonCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    private let reuseIdentifier = "AutomatonCell"

    // The number of cells across that the grid is
    private let horizontalCellCount = 40
    private var dataSource: [[Bool]] = []
    private var cycles = 1
    private var cycleTime = 1.0

    // This creates a dictionary to represent the rules of rule30
    private var rule30Dictionary: [[Bool]: Bool] = [
        [true, true, true] : false,
        [true, true, false] : false,
        [true, false, true] : false,
        [true, false, false] : true,
        [false, true, true] : true,
        [false, true, false] : true,
        [false, false, true] : true,
        [false, false, false] : false
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        seedRowData()
        cycle()
    }

    // Set the row data, trying to set the middle value to 'true'
    private func seedRowData() {
        var firstRow = [Bool](repeating: false, count: horizontalCellCount)
        firstRow[horizontalCellCount/2] = true

        dataSource.append(firstRow)
    }

    // This function will be used to "animate" the collection by adding new rows
    private func cycle() {
        // Every four seconds, do this and then repeat this function
        DispatchQueue.main.asyncAfter(deadline: .now() + cycleTime) {
            // Should never fail this guard
            guard let mostRecentRow = self.dataSource.first else {
                return
            }

            // Calculate the next row based off the most recent row calculated,
            // append it to our datasource
            self.dataSource.insert(self.calculateNextRow(currentRow: mostRecentRow), at: 0)

            self.cycles += 1
            self.collectionView.reloadData()
            self.cycle()
        }
    }

    private func calculateNextRow(currentRow: [Bool]) -> [Bool] {
        var nextRow: [Bool] = []

        for(index, cell) in currentRow.enumerated() {
            let leftCell = index == 0 ? false : currentRow[index - 1]
            let rightCell = index == currentRow.count - 1 ? false : currentRow[index + 1]

            // This will never be nil, so the optional coalescing shouldn't be a problem
            let newCell = rule30Dictionary[[leftCell, cell, rightCell]] ?? true

            nextRow.append(newCell)
        }

        return nextRow
    }
}


// MARK: - UICollectionViewDataSource
extension AutomatonCollectionViewController {

    // Each 'cycle' adds a new section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return horizontalCellCount
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let dataCell = dataSource[indexPath.section][indexPath.row]
        if dataCell {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .white
        }

        return cell
    }
}

extension AutomatonCollectionViewController: UICollectionViewDelegateFlowLayout{

    // Sets the size of the cells to be squares that will fill across based on the grid number
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth/CGFloat(horizontalCellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
