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

    // Warning: numbers above 29 will likely cause visual lag due to UICollectionView expense of displaying many cells
    // Suggestion: Use odd numbers to center the pattern properly
    // The number of cells across that the grid is
    private let horizontalCellCount = 29

    // This represents the current pattern and all past patterns of data
    private var dataSource: [[Bool]] = [[true]]

    // A count of how many cycles we have gone through, and how much time to wait between cycles
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

    // Assumptions about the current ruleset. We know that on rule30 new cells on the left and right are always 'true'
    private var rule30LeftEdge = true
    private var rule30RightEdge = true

    override func viewDidLoad() {
        super.viewDidLoad()

        cycle()
    }
}


// MARK: - UICollectionViewDataSource
extension AutomatonCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return horizontalCellCount
    }

    // We must take the middle section of our data and align it to the middle of our collectionview, which is why
    // this function is larger than normal. We could refactor this out into a seperate function for other displays.
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let dataSection = dataSource[indexPath.section]
        let dataCount = dataSection.count

        // If our dataCount is lower than the number of cells we display, we must add blank space on either side.
        if dataCount <= horizontalCellCount {
            // Amount of blank space on each side of pattern
            let spacerCount = (horizontalCellCount - dataCount) / 2

            if
                indexPath.row < spacerCount ||
                indexPath.row > spacerCount + dataCount - 1
            {
                cell.backgroundColor = .white
            } else {
                let color: UIColor = dataSection[indexPath.row - spacerCount] ? .red : .white
                cell.backgroundColor = color
            }
        } else {
            // Number of cells to ignore from each side of the data to fit the displayed cells
            let ignoreCount = (dataCount - horizontalCellCount) / 2
            let color: UIColor = dataSection[indexPath.row + ignoreCount] ? .red : .white
            cell.backgroundColor = color
        }

        return cell
    }
}

extension AutomatonCollectionViewController: UICollectionViewDelegateFlowLayout{

    // Sets the size of the cells to be squares that will fill across based on the grid number
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth/CGFloat(horizontalCellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Rule30 Helpers
extension AutomatonCollectionViewController {
    // This function is used to "animate" the collection by adding new rows
    private func cycle() {
        // Every [cycleTime] seconds, do this and then repeat this function
        DispatchQueue.main.asyncAfter(deadline: .now() + cycleTime) {
            // Should never fail this guard, but if we do we'll just pause indefinitely
            // The most recent row is the first because we prepend new data
            guard let mostRecentRow = self.dataSource.first else {
                return
            }

            // Calculate the next row based off the most recent row calculated, prepend it to our datasource
            let newRow = self.calculateNextRow(currentRow: mostRecentRow)
            self.dataSource.insert(newRow, at: 0)

            self.cycles += 1
            self.collectionView.reloadData()

            self.cycle()
        }
    }

    // Does the rule30 calculations and creates the next new row
    private func calculateNextRow(currentRow: [Bool]) -> [Bool] {
        var nextRow: [Bool] = []

        for(index, cell) in currentRow.enumerated() {
            let leftCell = index == 0 ? false : currentRow[index - 1]
            let rightCell = index == currentRow.count - 1 ? false : currentRow[index + 1]

            // This will never be nil, so the optional unwrapping shouldn't be a problem
            let newCell = rule30Dictionary[[leftCell, cell, rightCell]] ?? true

            nextRow.append(newCell)
        }

        // The array grows by two cells each round. We don't need to calculate these cells since they're constant
        // May refactor this if we decide to implement other rulesets that aren't edge-constant
        nextRow.insert(rule30LeftEdge, at: 0)
        nextRow.append(rule30RightEdge)
        return nextRow
    }
}
