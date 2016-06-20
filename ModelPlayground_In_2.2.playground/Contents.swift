/// Written in Swift 2.2.

import UIKit

extension Range {
    /// Returns the corresponding positions of start and end indice of
    /// 'rangeInSelf' in 'anotherRange'.
    /// Return 'nil', if endIndex of 'anotherRange' met before the endIndex of
    /// 'rangeInSelf' met.
    @warn_unused_result
    func range<T : ForwardIndexType>(in anotherRange: Range<T>, for rangeInSelf: Range) -> Range<T>? {
        var anotherStartIndexForRange: T?
        var anotherEndIndexForRange: T?
        var anotherSuccessor = anotherRange.startIndex
        for i in startIndex...endIndex {
            if anotherRange.endIndex.distanceTo(anotherRange.endIndex) > anotherSuccessor.distanceTo(anotherRange.endIndex) {
                break
            }
            if i == rangeInSelf.startIndex {
                anotherStartIndexForRange = anotherSuccessor
            }
            if i == rangeInSelf.endIndex {
                anotherEndIndexForRange = anotherSuccessor
            }
            if let start = anotherStartIndexForRange, end = anotherEndIndexForRange {
                return start..<end
            }
            anotherSuccessor = anotherSuccessor.successor()
        }
        return nil
    }
}

let rangeA = 0..<100
let rangeB = 50..<1000
let rangeC = -99..<(-60)
let rangeD = 0..<0

/// Range provided out of bounds of both base and in.
/// Returns 'nil'.
let range0 = rangeA.range(in: rangeA, for: 1000..<1001)
/// Range provided out of bounds of base.
/// Returns 'nil'.
let range1 = rangeA.range(in: rangeC, for: -9..<20)
/// Range provided out of bounds of in.
/// Returns 'nil'.
let range2 = rangeA.range(in: rangeC, for: 87..<90)
/// Range provided falls in both bounds of base and in.
/// Returns '-76..<-69'.
let range3 = rangeA.range(in: rangeC, for: 23..<30)
/// Empty range provided falls in both bounds of base and in.
/// Empty base.
/// Returns '0..<0'.
let range4 = rangeD.range(in: rangeD, for: 0..<0)
/// Non-empty base.
/// Returns '150..<150'.
let range5 = rangeB.range(in: rangeB, for: 150..<150)
/// Empty range provided out of bounds of both base and in.
/// Returns 'nil'.
let range6 = rangeB.range(in: rangeB, for: 0..<0)

extension CollectionType where Generator.Element : IntegerArithmeticType, Generator.Element == SubSequence.Generator.Element {
    /// For each element in 'self', get the delta from the corresponding one in
    /// 'from' and return as an 'Array'.
    /// Returns 'nil', if any elemnt in either arrays is missing.
    @warn_unused_result
    func deltas<T : CollectionType where T.Generator.Element == Self.Generator.Element, T.Generator.Element == T.SubSequence.Generator.Element>(from collection: T, for range: Range<Index>? = nil) -> [Generator.Element]? {
        if count as! Int != collection.count as! Int {
            return nil
        }
        let selfRange = range ?? indices
        guard let rangeInFrom = (indices).range(in: collection.indices, for: selfRange) else { return nil }
        let selfElementsInRange = self[selfRange]
        let fromElementsInRange = collection[rangeInFrom]
        var fromGen = fromElementsInRange.generate()
        var deltas: [Generator.Element] = []
        for selfElement in selfElementsInRange {
            if let fromElement = fromGen.next() {
                deltas.append(selfElement - fromElement)
            }
        }
        return deltas
    }
    
    /// Returns all ranges with continuous non-zero delta in 'Tuple' with
    /// 'Range' as first element and max-delta of this range as second.
    /// Returns 'nil', if any elemnt in either arrays is missing.
    @warn_unused_result
    func nonZeroMaxDeltaRangesAndDeltas<T : CollectionType where T.Generator.Element == Self.Generator.Element, T.Generator.Element == T.SubSequence.Generator.Element>(from collection: T) -> [(Range<Index>, Generator.Element)]? {
        guard let deltas = deltas(from: collection) else { return nil }
        var results: [(Range<Index>, Generator.Element)] = []
        if deltas.count == 0 { return results }
        let zero = deltas.first! - deltas.first!
        var headIndex: Index?
        var tailIndex: Index?
        var deltasGen = deltas.generate()
        var deltaForRange: Generator.Element?
        for i in startIndex...endIndex {
            tailIndex = i
            var newPieceReady = false
            let delta = deltasGen.next()
            if i == endIndex {
                if headIndex != nil { newPieceReady = true }
            }
            else {
                guard let deltaAtPosition = delta else {
                    fatalError("func nonZeroMaxDeltaRangesAndDeltas came up with invalid deltas.")
                }
                if deltaAtPosition != zero {
                    if let _ = headIndex, deltaForRangeHere = deltaForRange {
                        if deltaForRangeHere * deltaAtPosition < zero { newPieceReady = true }
                    }
                    else {
                        headIndex = i
                    }
                    if !newPieceReady {
                        deltaForRange = (deltaForRange == nil) ? deltaAtPosition : (deltaAtPosition > zero ? min(deltaForRange!, deltaAtPosition) : max(deltaForRange!, deltaAtPosition))
                    }
                }
                else {
                    newPieceReady = true
                }
            }
            if newPieceReady {
                if let start = headIndex, end = tailIndex, deltaHere = deltaForRange {
                    results.append((start..<end, deltaHere))
                }
                headIndex = nil
                tailIndex = nil
                deltaForRange = nil
                if delta != nil && delta! != zero {
                    headIndex = i
                    deltaForRange = delta
                }
            }
        }
        return results
    }
    /// Returns a new 'Array' with elements in 'range' modified by 'delta'.
    /// Returns 'nil', if 'range' is out of bounds.
    @warn_unused_result
    func apply(delta: Generator.Element, to range: Range<Index>) -> [Generator.Element]? {
        if startIndex.distanceTo(range.startIndex) < 0 || endIndex.distanceTo(range.endIndex) > 0 { return nil }
        var deltas: [Generator.Element] = []
        let zero = delta - delta
        deltas.appendContentsOf(Repeat(count: ((startIndex..<range.startIndex).count as! Int), repeatedValue: zero))
        deltas.appendContentsOf(Repeat(count: ((range.startIndex..<range.endIndex).count as! Int), repeatedValue: delta))
        deltas.appendContentsOf(Repeat(count: ((range.endIndex..<endIndex).count as! Int), repeatedValue: zero))
        var newNumbers: [Generator.Element] = []
        var deltasGen = deltas.generate()
        for number in self {
            newNumbers.append(number + deltasGen.next()!)
        }
        return newNumbers
    }
    
}

let arrayA = [3, 12, 32, 15]
let arrayB = [32, 152, 68, 8]
let arrayC = [1]
let arrayD = [2, 14, 31, 80]
let arrayE = [3, 12, 44, 32, 15]
let arrayF = [32, 152, 44, 68, 8]
let arrayG = [1, 3, 12, 44, 32, 15, 2]
let arrayH = [1, 32, 152, 44, 68, 8, 2]

/// No-missing-element array pair with valid non-empty range.
/// Returns '[-29, -140, -36, 7]'.
let deltas0 = arrayA.deltas(from: arrayB)
/// No-missing-element array pair with valid empty range.
/// Returns '[]'.
let deltas1 = arrayA.deltas(from: arrayB, for: 0..<0)

/// No-missing-element array pair with out of bounds range.
/// Returns 'nil'.
let deltas2 = arrayA.deltas(from: arrayB, for: 0..<10)
/// Missing-element array pair with valid range.
/// Returns 'nil'.
let deltas3 = arrayA.deltas(from: arrayC, for: 0..<1)

/// No-missing-element array pair.
/// Returns '[(Range(0..<3), -29), (Range(3..<4), 7)]'.
let options0 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayB)
/// Returns '[(Range(0..<3), 29), (Range(3..<4), -7)]'.
let options1 = arrayB.nonZeroMaxDeltaRangesAndDeltas(from: arrayA)
/// Returns '[(Range(0..<2), -29), (Range(3..<4), -36), (Range(4..<5), 7)]'.
let options2 = arrayE.nonZeroMaxDeltaRangesAndDeltas(from: arrayF)
/// Returns '[(Range(0..<2), 29), (Range(3..<4), 36), (Range(4..<5), -7)]'.
let options3 = arrayF.nonZeroMaxDeltaRangesAndDeltas(from: arrayE)
/// Returns '[(Range(1..<3), -29), (Range(4..<5), -36), (Range(5..<6), 7)]'.
let options4 = arrayG.nonZeroMaxDeltaRangesAndDeltas(from: arrayH)
/// Returns '[(Range(1..<3), 29), (Range(4..<5), 36), (Range(5..<6), -7)]'.
let options5 = arrayH.nonZeroMaxDeltaRangesAndDeltas(from: arrayG)
/// Returns '[(Range(0..<1), 1), (Range(1..<2), -2), (Range(2..<4), 1), (Range(3..<4), -65)]'.
let options6 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayD)

/// Missing-element array pair.
/// Returns 'nil'.
let options7 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayC)

/// Apply to valid range.
/// Returns '[1, 82, 202, 94, 68, 8, 2]'.
let applied0 = arrayH.apply(50, to: 1..<4)
/// Apply to invalid range.
/// Returns 'nil'.
let applied1 = arrayH.apply(50, to: 10..<40)
/// Returns 'nil'.
let applied2 = arrayH.apply(50, to: 2..<8)
/// Returns '[1, 32, 202, 94, 118, 58, 52]'.
let applied3 = arrayH.apply(50, to: 2..<7)
/// Returns 'nil'.
let applied4 = arrayH.apply(50, to: -1..<7)

extension Array where Element : IntegerArithmeticType {
    /// Returns all deltas, ranges applied and new arrays generated to reach
    /// self.
    /// Returns 'nil', if there is no corresponding element in either array or
    /// 'deltaPicker' fails to pick.
    @warn_unused_result
    func deltasAndRangesWithNewArrays(from collection: [Element], @noescape deltaPicker: ([(Range<Int>, Element)]) -> (Range<Int>, Element)?) -> (deltas: [Generator.Element], ranges: [Range<Int>], newArrays: [[Element]])? {
        if count != collection.count { return nil }
        var deltas: [Generator.Element] = []
        var ranges: [Range<Int>] = []
        var newArrays: [[Element]] = []
        var newCollection = collection
        var numberOfOptions = nonZeroMaxDeltaRangesAndDeltas(from: collection)?.count ?? 0
        while numberOfOptions > 0 {
            if let options = nonZeroMaxDeltaRangesAndDeltas(from: newCollection) {
                numberOfOptions = options.count
                if numberOfOptions > 0 {
                    guard let pick = deltaPicker(options)
                        else { return nil }
                    deltas.append(pick.1)
                    ranges.append(pick.0)
                    newCollection = (newArrays.last ?? collection).apply(pick.1, to: pick.0)!
                    newArrays.append(newCollection)
                }
            }
            else {
                return nil
            }
        }
        return (deltas, ranges, newArrays)
    }
}

let normalTargetArray = [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 4]
let normalInitialArray = [1, 23, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3]
let shorterArray = [1]
let longerArray = [Int](count: 15, repeatedValue: 55)

/// No corresponding element in either array.
/// 'from' is shorter.
/// Return 'nil'.
let toTarget0 = normalTargetArray.deltasAndRangesWithNewArrays(from: shorterArray) { $0.first }
/// 'from' is longer.
/// Return 'nil'.
let toTarget1 = normalTargetArray.deltasAndRangesWithNewArrays(from: longerArray) { $0.first }
/// 'deltaPicker' not working properly.
/// Return 'nil'.
let toTarget2 = normalTargetArray.deltasAndRangesWithNewArrays(from: longerArray) { _ in return nil }
/// Normal.
/// Returns '([41, 257, 409, -400, 1892, -21, 610, 10497, 1], [Range(0..<2), Range(1..<2), Range(3..<4), Range(4..<5), Range(6..<7), Range(7..<8), Range(8..<10), Range(8..<9), Range(11..<12)], [[42, 64, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 1844, 653, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 4]])'.
let toTarget3 = normalTargetArray.deltasAndRangesWithNewArrays(from: normalInitialArray) { $0.first }
/// normalOutcome each step breakdown:
/// step: 0
/// newCollection: [1, 23, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3]
/// options: [(Range(0..<2), 41), (Range(3..<4), 409), (Range(4..<5), -400), (Range(6..<7), 1892), (Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(0..<2), 41)
/// step: 1
/// newCollection: [42, 64, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3]
/// options: [(Range(1..<2), 257), (Range(3..<4), 409), (Range(4..<5), -400), (Range(6..<7), 1892), (Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(1..<2), 257)
/// step: 2
/// newCollection: [42, 321, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3]
/// options: [(Range(3..<4), 409), (Range(4..<5), -400), (Range(6..<7), 1892), (Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(3..<4), 409)
/// step: 3
/// newCollection: [42, 321, 53, 532, 412, 8, 231, 23, 1234, 43, 1, 3]
/// options: [(Range(4..<5), -400), (Range(6..<7), 1892), (Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(4..<5), -400)
/// step: 4
/// newCollection: [42, 321, 53, 532, 12, 8, 231, 23, 1234, 43, 1, 3]
/// options: [(Range(6..<7), 1892), (Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(6..<7), 1892)
/// step: 5
/// newCollection: [42, 321, 53, 532, 12, 8, 2123, 23, 1234, 43, 1, 3]
/// options: [(Range(7..<8), -21), (Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(7..<8), -21)
/// step: 6
/// newCollection: [42, 321, 53, 532, 12, 8, 2123, 2, 1234, 43, 1, 3]
/// options: [(Range(8..<10), 610), (Range(11..<12), 1)]
/// pick: (Range(8..<10), 610)
/// step: 7
/// newCollection: [42, 321, 53, 532, 12, 8, 2123, 2, 1844, 653, 1, 3]
/// options: [(Range(8..<9), 10497), (Range(11..<12), 1)]
/// pick: (Range(8..<9), 10497)
/// step: 8
/// newCollection: [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 3]
/// options: [(Range(11..<12), 1)]
/// pick: (Range(11..<12), 1)
/// step: 9
/// newCollection: [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 4]
/// options: []


//protocol AccuracyTolerable: Numberable {
//    func isEqual(to another: Self) -> Bool
//    func isGreater(than another: Self) -> Bool
//    func isLess(than aother: Self) -> Bool
//}
//
//struct AccuracyTolerance {
//    let forDoubleUpper: Double
//    let forDoubleLower: Double
//    let forFloatUpper: Float
//    let forFloatLower: Float
//    let forCGFloatUpper: CGFloat
//    let forCGFloatLower: CGFloat
//}
//
//let accuracy = AccuracyTolerance(
//    forDoubleUpper: 0.000001,
//    forDoubleLower: -0.000001,
//    forFloatUpper: 0.000001,
//    forFloatLower: -0.000001,
//    forCGFloatUpper: 0.000001,
//    forCGFloatLower: -0.000001)
//
//extension AccuracyTolerable {
//    /// Returns if 'self' == 'another'.
//    @warn_unused_result
//    func isEqual(to another: Self) -> Bool {
//        switch another - self {
//        case let delta as Double:
//            return delta <= accuracy.forDoubleUpper && delta >= accuracy.forDoubleLower
//        case let delta as Float:
//            return delta <= accuracy.forFloatUpper && delta >= accuracy.forFloatLower
//        case let delta as CGFloat:
//            return delta <= accuracy.forCGFloatUpper && delta >= accuracy.forCGFloatLower
//        default:
//            fatalError("type is not implemented for AccuracyTolerable.")
//        }
//    }
//    /// Returns if 'self' > self.
//    @warn_unused_result
//    func isGreater(than another: Self) -> Bool {
//        switch self - another {
//        case let delta as Double:
//            return delta > accuracy.forDoubleUpper
//        case let delta as Float:
//            return delta > accuracy.forFloatUpper
//        case let delta as CGFloat:
//            return delta > accuracy.forCGFloatUpper
//        default:
//            fatalError("type is not implemented for AccuracyTolerable.")
//        }
//    }
//    /// Returns if 'self' < 'another'.
//    @warn_unused_result
//    func isLess(than another: Self) -> Bool {
//        switch self - another {
//        case let delta as Double:
//            return delta < accuracy.forDoubleLower
//        case let delta as Float:
//            return delta < accuracy.forFloatLower
//        case let delta as CGFloat:
//            return delta < accuracy.forCGFloatLower
//        default:
//            fatalError("type is not implemented for AccuracyTolerable.")
//        }
//    }
//}
//
//extension Double: AccuracyTolerable {}
//extension Float: AccuracyTolerable {}
//extension CGFloat: AccuracyTolerable {}
