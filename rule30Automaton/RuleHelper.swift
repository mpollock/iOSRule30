//
//  RuleHelper.swift
//  rule30Automaton
//
//  Created by Michael P on 1/22/21.
//

import Foundation

final class RuleHelper {

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

    // Does the rule30 calculations and creates the next new row
    func calculateNextRow(currentRow: [Bool]) -> [Bool] {
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

    // Using the input of a 'section' of data (a row), and the index of a cell, calculate the cell state
    // This must keep in mind aligning the centers of the two datasets
    func calculateCellState(_ dataSection: [Bool], _ indexPath: IndexPath, _ horizontalCellCount: Int) -> Bool {
        let dataCount = dataSection.count

        // If our dataCount is lower than the number of cells we display, we must add blank space on either side.
        if dataCount <= horizontalCellCount {
            // Amount of blank space on each side of pattern
            let spacerCount = (horizontalCellCount - dataCount) / 2

            if
                indexPath.row < spacerCount ||
                indexPath.row > spacerCount + dataCount - 1
            {
                return false
            } else {
                return dataSection[indexPath.row - spacerCount] ? true : false
            }
        } else {
            // Number of cells to ignore from each side of the data to fit the displayed cells
            let ignoreCount = (dataCount - horizontalCellCount) / 2
            return dataSection[indexPath.row + ignoreCount] ? true : false
        }
    }
}
