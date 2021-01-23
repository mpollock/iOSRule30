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

    private let ruleHelper = RuleHelper()

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        cycle()
    }

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
            let newRow = self.ruleHelper.calculateNextRow(currentRow: mostRecentRow)
            self.dataSource.insert(newRow, at: 0)

            self.cycles += 1
            self.collectionView.reloadData()

            self.cycle()
        }
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
        let cellState = ruleHelper.calculateCellState(dataSource[indexPath.section], indexPath, horizontalCellCount)
        cell.backgroundColor = cellState ? .black : .white

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
