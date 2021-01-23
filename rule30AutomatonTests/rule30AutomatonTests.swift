//
//  rule30AutomatonTests.swift
//  rule30AutomatonTests
//
//  Created by Michael P on 1/22/21.
//

import XCTest
@testable import rule30Automaton

class rule30AutomatonTests: XCTestCase {

    private let ruleHelper = RuleHelper()
    private let horizontalCellCount = 5
    private let firstItem = IndexPath(row: 0, section: 0)
    private let middleItem = IndexPath(row: 2, section: 0)
    private let lastItem = IndexPath(row: 4, section: 0)

    func testCalculateNextRow() {
        let firstRow = [true]
        let secondRow = ruleHelper.calculateNextRow(currentRow: firstRow)
        let thirdRow = ruleHelper.calculateNextRow(currentRow: secondRow)
        let fourthRow = ruleHelper.calculateNextRow(currentRow: thirdRow)

        XCTAssertEqual(secondRow, [true, true, true])
        XCTAssertEqual(thirdRow, [true, true, false, false, true])
        XCTAssertEqual(fourthRow, [true, true, false, true, true, true, true])
    }

    // The cells first and last exist outside of the data, and are thus "blank", or "false"
    func testCalculateCellStateWithSmallData() {
        let dataSection = [true, true, true]

        let firstCellState = ruleHelper.calculateCellState(dataSection, firstItem, horizontalCellCount)
        let middleCellState = ruleHelper.calculateCellState(dataSection, middleItem, horizontalCellCount)
        let lastCellState = ruleHelper.calculateCellState(dataSection, lastItem, horizontalCellCount)

        XCTAssertEqual(firstCellState, false)
        XCTAssertEqual(middleCellState, true)
        XCTAssertEqual(lastCellState, false)
    }

    // These cells should all match, first to first, middle to middle, last to last
    func testCalculateCellStateWithData() {
        let dataSection = [true, false, true, false, false]

        let firstCellState = ruleHelper.calculateCellState(dataSection, firstItem, horizontalCellCount)
        let middleCellState = ruleHelper.calculateCellState(dataSection, middleItem, horizontalCellCount)
        let lastCellState = ruleHelper.calculateCellState(dataSection, lastItem, horizontalCellCount)

        XCTAssertEqual(firstCellState, true)
        XCTAssertEqual(middleCellState, true)
        XCTAssertEqual(lastCellState, false)
    }

    // The first and last data cells should exist outside of the displayed cells, so the "first" cell should match
    // the second dataSection item, and "last" should match second to last dataSection item
    func testCalculateCellStateWithLargeData() {
        let dataSection = [true, false, true, true, true, true, false]

        let firstCellState = ruleHelper.calculateCellState(dataSection, firstItem, horizontalCellCount)
        let middleCellState = ruleHelper.calculateCellState(dataSection, middleItem, horizontalCellCount)
        let lastCellState = ruleHelper.calculateCellState(dataSection, lastItem, horizontalCellCount)

        XCTAssertEqual(firstCellState, false)
        XCTAssertEqual(middleCellState, true)
        XCTAssertEqual(lastCellState, true)
    }

}
