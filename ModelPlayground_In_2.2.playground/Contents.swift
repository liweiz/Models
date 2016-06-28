/// Written in Swift 2.2.

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

struct Test_Ext_Range_Range {
    let testName: String,
    selfRange: Range<Int>,
    anotherRange: Range<Int>,
    rangeInSelf: Range<Int>,
    expectedOutcome: Range<Int>?
    func test() -> Bool {
        if let outcome = selfRange.range(in: anotherRange, for: rangeInSelf) {
            if let out = expectedOutcome {
                return outcome == out
            }
        }
        else if expectedOutcome == nil {
            return true
        }
        return false
    }
}

let tests_Ext_Range_Range = [
    Test_Ext_Range_Range(testName: "Range provided out of bounds of both base and in.", selfRange: rangeA, anotherRange: rangeB, rangeInSelf: 1000..<1001, expectedOutcome: nil),
    Test_Ext_Range_Range(testName: "Range provided out of bounds of base.", selfRange: rangeA, anotherRange: rangeC, rangeInSelf: -9..<20, expectedOutcome: nil),
    Test_Ext_Range_Range(testName: "Range provided out of bounds of in.", selfRange: rangeA, anotherRange: rangeC, rangeInSelf: 87..<90, expectedOutcome: nil),
    Test_Ext_Range_Range(testName: "Range provided falls in both bounds of base and in.", selfRange: rangeA, anotherRange: rangeC, rangeInSelf: 23..<30, expectedOutcome: -76..<(-69)),
    Test_Ext_Range_Range(testName: "Empty range provided falls in both bounds of base and in.", selfRange: rangeD, anotherRange: rangeD, rangeInSelf: 0..<0, expectedOutcome: 0..<0),
    Test_Ext_Range_Range(testName: "Non-empty base.", selfRange: rangeB, anotherRange: rangeB, rangeInSelf: 150..<150, expectedOutcome: 150..<150),
    Test_Ext_Range_Range(testName: "Empty range provided out of bounds of both base and in.", selfRange: rangeB, anotherRange: rangeB, rangeInSelf: 0..<0, expectedOutcome: nil)
]

func test_tests_Ext_Range_Range() {
    print("Test START: tests_Ext_Range_Range")
    for t in tests_Ext_Range_Range {
        print("test: \(t.testName) => START")
        assert(t.test())
        print("test: \(t.testName) => END")
    }
    print("Test END: tests_Ext_Range_Range")
}

test_tests_Ext_Range_Range()

/// Range provided out of bounds of both base and in.
/// Returns 'nil'.
let range0 = rangeA.range(in: rangeA, for: 1000..<1001)
print("range0: \(range0)")
/// Range provided out of bounds of base.
/// Returns 'nil'.
let range1 = rangeA.range(in: rangeC, for: -9..<20)
print("range1: \(range1)")
/// Range provided out of bounds of in.
/// Returns 'nil'.
let range2 = rangeA.range(in: rangeC, for: 87..<90)
print("range2: \(range2)")
/// Range provided falls in both bounds of base and in.
/// Returns '-76..<-69'.
let range3 = rangeA.range(in: rangeC, for: 23..<30)
print("range3: \(range3)")
/// Empty range provided falls in both bounds of base and in.
/// Empty base.
/// Returns '0..<0'.
let range4 = rangeD.range(in: rangeD, for: 0..<0)
print("range4: \(range4)")
/// Non-empty base.
/// Returns '150..<150'.
let range5 = rangeB.range(in: rangeB, for: 150..<150)
print("range5: \(range5)")
/// Empty range provided out of bounds of both base and in.
/// Returns 'nil'.
let range6 = rangeB.range(in: rangeB, for: 0..<0)
print("range6: \(range6)")


protocol Arithmeticable {
    func +(_: Self, _: Self) -> Self
    func -(_: Self, _: Self) -> Self
    func *(_: Self, _: Self) -> Self
    func /(_: Self, _: Self) -> Self
}

extension Int: Arithmeticable {}
extension Int8: Arithmeticable {}
extension Int16: Arithmeticable {}
extension Int32: Arithmeticable {}
extension Int64: Arithmeticable {}
extension UInt: Arithmeticable {}
extension UInt8: Arithmeticable {}
extension UInt16: Arithmeticable {}
extension UInt32: Arithmeticable {}
extension UInt64: Arithmeticable {}

extension Double: Arithmeticable {}
extension Float: Arithmeticable {}


protocol ControlledComparable {
    func isEqual(to another: Self) -> Bool
    func isGreater(than another: Self) -> Bool
    func isLess(than another: Self) -> Bool
}

extension IntegerArithmeticType {
    @warn_unused_result
    func isEqual(to another: Self) -> Bool {
        return self == another
    }
    @warn_unused_result
    func isGreater(than another: Self) -> Bool {
        return self > another
    }
    @warn_unused_result
    func isLess(than another: Self) -> Bool {
        return self < another
    }
}

extension Int: ControlledComparable {}
extension Int8: ControlledComparable {}
extension Int16: ControlledComparable {}
extension Int32: ControlledComparable {}
extension Int64: ControlledComparable {}
extension UInt: ControlledComparable {}
extension UInt8: ControlledComparable {}
extension UInt16: ControlledComparable {}
extension UInt32: ControlledComparable {}
extension UInt64: ControlledComparable {}

let accuracyPctInDouble: Double = 0.001 * 0.01

extension Double {
    @warn_unused_result
    func isEqual(to another: Double) -> Bool {
        return self - another > -accuracyPctInDouble && self - another < accuracyPctInDouble
    }
    @warn_unused_result
    func isGreater(than another: Double) -> Bool {
        return self - another >= accuracyPctInDouble
    }
    @warn_unused_result
    func isLess(than another: Double) -> Bool {
        return self - another <= -accuracyPctInDouble
    }
}

extension Double: ControlledComparable {}

let accuracyPctInFloat: Float = 0.0001

extension Float {
    @warn_unused_result
    func isEqual(to another: Float) -> Bool {
        return self - another > -accuracyPctInFloat && self - another < accuracyPctInFloat
    }
    @warn_unused_result
    func isGreater(than another: Float) -> Bool {
        return self - another >= accuracyPctInFloat
    }
    @warn_unused_result
    func isLess(than another: Float) -> Bool {
        return self - another <= -accuracyPctInFloat
    }
}

extension Float: ControlledComparable {}

func min<T : ControlledComparable>(x: T, _ y: T) -> T {
    if x.isGreater(than: y) { return y }
    return x
}

func max<T : ControlledComparable>(x: T, _ y: T) -> T {
    if x.isLess(than: y) { return y }
    return x
}

extension CollectionType where Generator.Element : ControlledComparable, Generator.Element : Arithmeticable, Generator.Element == SubSequence.Generator.Element {
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
        print("deltas: \(deltas)")
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
            if i == endIndex && headIndex != nil { newPieceReady = true }
            if i != endIndex {
                guard let deltaAtPosition = delta else {
                    fatalError("func nonZeroMaxDeltaRangesAndDeltas came up with invalid deltas.")
                }
                if !deltaAtPosition.isEqual(to: zero) {
                    if let _ = headIndex, deltaForRangeHere = deltaForRange {
                        if (deltaForRangeHere * deltaAtPosition).isLess(than: zero) { newPieceReady = true }
                    }
                    else {
                        headIndex = i
                    }
                    if !newPieceReady {
                        deltaForRange = (deltaForRange == nil) ? deltaAtPosition : (deltaAtPosition.isGreater(than: zero) ? min(deltaForRange!, deltaAtPosition) : max(deltaForRange!, deltaAtPosition))
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
                if delta != nil && !delta!.isEqual(to: zero) {
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

let arrayA: [Int] = [3, 12, 32, 15]
let arrayB: [Int] = [32, 152, 68, 8]
let arrayC: [Int] = [1]
let arrayD: [Int] = [2, 14, 31, 80]
let arrayE: [Int] = [3, 12, 44, 32, 15]
let arrayF: [Int] = [32, 152, 44, 68, 8]
let arrayG: [Int] = [1, 3, 12, 44, 32, 15, 2]
let arrayH: [Int] = [1, 32, 152, 44, 68, 8, 2]

struct Test_Ext_Collection_Deltas_Int {
    let testName: String,
    collection: Array<Int>,
    fromCollection: Array<Int>,
    forRange: Range<Int>,
    expectedOutcome: Array<Int>?
    func test() -> Bool {
        if let outcome = collection.deltas(from: fromCollection, for: forRange) {
            if let out = expectedOutcome {
                return outcome == out
            }
        }
        else if expectedOutcome == nil {
            return true
        }
        return false
    }
}

let tests_Ext_Collection_Deltas_Int = [
    Test_Ext_Collection_Deltas_Int(testName: "No-missing-element array pair with valid non-empty range.", collection: arrayA, fromCollection: arrayB, forRange: arrayA.indices, expectedOutcome: [-29, -140, -36, 7]),
    Test_Ext_Collection_Deltas_Int(testName: "No-missing-element array pair with valid empty range.", collection: arrayA, fromCollection: arrayB, forRange: 0..<0, expectedOutcome: []),
    Test_Ext_Collection_Deltas_Int(testName: "No-missing-element array pair with out of bounds range.", collection: arrayA, fromCollection: arrayB, forRange: 0..<10, expectedOutcome: nil),
    Test_Ext_Collection_Deltas_Int(testName: "Missing-element array pair with valid range.", collection: arrayA, fromCollection: arrayC, forRange: 0..<1, expectedOutcome: nil)
]

func test_tests_Ext_Collection_Deltas_Int() {
    print("Test START: tests_Ext_Collection_Deltas_Int")
    for t in tests_Ext_Collection_Deltas_Int {
        print("test: \(t.testName) => START")
        assert(t.test())
        print("test: \(t.testName) => END")
    }
    print("Test END: tests_Ext_Collection_Deltas_Int")
}

test_tests_Ext_Collection_Deltas_Int()

func ==(lhs: [Float], rhs: [Float]) -> Bool {
    if lhs.count != rhs.count { return false }
    for i in lhs.indices {
        if !lhs[i].isEqual(to: rhs[i]) { return false }
    }
    return true
}

let arrayFloatA: [Float] = [0.0000001, 0]
let arrayFloatB: [Float] = [0, 0.0000001]
let arrayFloatC: [Float] = [0.001, 0.0009, 0.0009001, 0.0011, 0.00101]
let arrayFloatD: [Float] = [0.001, 0.001, 0.001, 0.001, 0.001]

struct Test_Ext_Collection_Deltas_Float {
    let testName: String,
    collection: Array<Float>,
    fromCollection: Array<Float>,
    forRange: Range<Int>,
    expectedOutcome: Array<Float>?
    func test() -> Bool {
        if let outcome = collection.deltas(from: fromCollection, for: forRange) {
            print(outcome)
            if let out = expectedOutcome {
                return outcome == out
            }
        }
        else if expectedOutcome == nil {
            return true
        }
        return false
    }
}

let tests_Ext_Collection_Deltas_Float = [
    Test_Ext_Collection_Deltas_Float(testName: "No-missing-element array pair with valid non-empty range.", collection: arrayFloatA, fromCollection: arrayFloatB, forRange: arrayFloatA.indices, expectedOutcome: [0, 0]),
    Test_Ext_Collection_Deltas_Float(testName: "No-missing-element array pair with valid non-empty range. Tests on all boundaries.", collection: arrayFloatC, fromCollection: arrayFloatD, forRange: arrayFloatC.indices, expectedOutcome: [0, -0.0001, 0, 0.0001, 0]),
    Test_Ext_Collection_Deltas_Float(testName: "No-missing-element array pair with valid empty range.", collection: arrayFloatC, fromCollection: arrayFloatD, forRange: 0..<0, expectedOutcome: []),
    Test_Ext_Collection_Deltas_Float(testName: "No-missing-element array pair with out of bounds range.", collection: arrayFloatC, fromCollection: arrayFloatD, forRange: 0..<10, expectedOutcome: nil),
    Test_Ext_Collection_Deltas_Float(testName: "No-missing-element array pair with out of bounds empty range.", collection: arrayFloatC, fromCollection: arrayFloatD, forRange: 10..<10, expectedOutcome: nil),
    Test_Ext_Collection_Deltas_Float(testName: "Missing-element array pair with valid range.", collection: arrayFloatC, fromCollection: arrayFloatA, forRange: 0..<1, expectedOutcome: nil)
]

func test_tests_Ext_Collection_Deltas_Float() {
    print("Test START: tests_Ext_Collection_Deltas_Float")
    for t in tests_Ext_Collection_Deltas_Float {
        print("test: \(t.testName) => START")
        assert(t.test())
        print("test: \(t.testName) => END")
    }
    print("Test END: tests_Ext_Collection_Deltas_Float")
}

test_tests_Ext_Collection_Deltas_Float()

let arrayFloatE: [Float] = [0.001, 0.0009, 0.0009001, 0.0012, 0.00101]
let arrayFloatF: [Float] = [0.001, 0.001, 0.001, 0.001, 0.001]
let arrayFloatG: [Float] = [1, -1, -0.9, 0.3, 2]

func ==(lhs: [(Range<Int>, Float)], rhs: [(Range<Int>, Float)]) -> Bool {
    if lhs.count == rhs.count {
        for i in lhs.indices {
            let l = lhs[i]
            let r = rhs[i]
            if l.0 != r.0 { return false }
            if !l.1.isEqual(to: r.1) { return false }
        }
        return true
    }
    return false
}

struct Test_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float {
    let testName: String
    let collection: Array<Float>
    let fromCollection: Array<Float>
    let expectedOutcome: [(Range<Int>, Float)]?
    func test() -> Bool {
        if let outcome = collection.nonZeroMaxDeltaRangesAndDeltas(from: fromCollection) {
            print(outcome)
            if let out = expectedOutcome {
                return outcome == out
            }
        }
        else if expectedOutcome == nil {
            return true
        }
        return false
    }
}

let tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float = [
    Test_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float(testName: "No-missing-element array pair.", collection: arrayFloatE, fromCollection: arrayFloatF, expectedOutcome: [(1..<2, -0.0001), (3..<4, 0.0002)]),
    Test_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float(testName: "No-missing-element array pair.", collection: arrayFloatG, fromCollection: arrayFloatF, expectedOutcome: [(0..<1, 0.999), (1..<3, -0.901), (3..<5, 0.299)])
]

func test_tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float() {
    print("Test START: tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float")
    for t in tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float {
        print("test: \(t.testName) => START")
        assert(t.test())
        print("test: \(t.testName) => END")
    }
    print("Test END: tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float")
}

test_tests_Ext_Collection_nonZeroMaxDeltaRangesAndDeltas_Float()

/// No-missing-element array pair with valid non-empty range.
/// Returns '[-29, -140, -36, 7]'.
let deltas0 = arrayA.deltas(from: arrayB)
print("deltas0: \(deltas0)")

/// No-missing-element array pair with valid empty range.
/// Returns '[]'.
let deltas1 = arrayA.deltas(from: arrayB, for: 0..<0)
print("deltas1: \(deltas1)")

/// No-missing-element array pair with out of bounds range.
/// Returns 'nil'.
let deltas2 = arrayA.deltas(from: arrayB, for: 0..<10)
print("deltas2: \(deltas2)")
/// Missing-element array pair with valid range.
/// Returns 'nil'.
let deltas3 = arrayA.deltas(from: arrayC, for: 0..<1)
print("deltas3: \(deltas3)")

/// No-missing-element array pair.
/// Returns '[(Range(0..<3), -29), (Range(3..<4), 7)]'.
let options0 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayB)
print("options0: \(options0)")
/// Returns '[(Range(0..<3), 29), (Range(3..<4), -7)]'.
let options1 = arrayB.nonZeroMaxDeltaRangesAndDeltas(from: arrayA)
print("options1: \(options1)")
/// Returns '[(Range(0..<2), -29), (Range(3..<4), -36), (Range(4..<5), 7)]'.
let options2 = arrayE.nonZeroMaxDeltaRangesAndDeltas(from: arrayF)
print("options2: \(options2)")
/// Returns '[(Range(0..<2), 29), (Range(3..<4), 36), (Range(4..<5), -7)]'.
let options3 = arrayF.nonZeroMaxDeltaRangesAndDeltas(from: arrayE)
print("options3: \(options3)")
/// Returns '[(Range(1..<3), -29), (Range(4..<5), -36), (Range(5..<6), 7)]'.
let options4 = arrayG.nonZeroMaxDeltaRangesAndDeltas(from: arrayH)
print("options4: \(options4)")
/// Returns '[(Range(1..<3), 29), (Range(4..<5), 36), (Range(5..<6), -7)]'.
let options5 = arrayH.nonZeroMaxDeltaRangesAndDeltas(from: arrayG)
print("options5: \(options5)")
/// Returns '[(Range(0..<1), 1), (Range(1..<2), -2), (Range(2..<4), 1), (Range(3..<4), -65)]'.
let options6 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayD)
print("options6: \(options6)")

/// Missing-element array pair.
/// Returns 'nil'.
let options7 = arrayA.nonZeroMaxDeltaRangesAndDeltas(from: arrayC)
print("options7: \(options7)")

/// Apply to valid range.
/// Returns '[1, 82, 202, 94, 68, 8, 2]'.
let applied0 = arrayH.apply(50, to: 1..<4)
print("applied0: \(applied0)")
/// Apply to invalid range.
/// Returns 'nil'.
let applied1 = arrayH.apply(50, to: 10..<40)
print("applied1: \(applied1)")
/// Returns 'nil'.
let applied2 = arrayH.apply(50, to: 2..<8)
print("applied2: \(applied2)")
/// Returns '[1, 32, 202, 94, 118, 58, 52]'.
let applied3 = arrayH.apply(50, to: 2..<7)
print("applied3: \(applied3)")
/// Returns 'nil'.
let applied4 = arrayH.apply(50, to: -1..<7)
print("applied4: \(applied4)")

extension Array where Element : ControlledComparable, Element: Arithmeticable {
    /// Returns all deltas, ranges applied and new arrays generated to reach
    /// self.
    /// Returns 'nil', if there is no corresponding element in either array or
    /// 'deltaPicker' fails to pick.
    @warn_unused_result
    func deltasAndRangesWithNewArrays(from array: [Element], @noescape deltaPicker: ([(Range<Int>, Element)]) -> (Range<Int>, Element)?) -> (deltas: [Generator.Element], ranges: [Range<Int>], newArrays: [[Element]])? {
        if count != array.count { return nil }
        var deltas: [Generator.Element] = []
        var ranges: [Range<Int>] = []
        var newArrays: [[Element]] = []
        var newCollection = array
        var numberOfOptions = nonZeroMaxDeltaRangesAndDeltas(from: array)?.count ?? 0
        while numberOfOptions > 0 {
            if let options = nonZeroMaxDeltaRangesAndDeltas(from: newCollection) {
                print("OPTIONS: \(options)")
                numberOfOptions = options.count
                if numberOfOptions > 0 {
                    guard let pick = deltaPicker(options)
                        else { return nil }
                    deltas.append(pick.1)
                    ranges.append(pick.0)
                    newCollection = (newArrays.last ?? array).apply(pick.1, to: pick.0)!
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

func ==(lhs: [[Float]], rhs: [[Float]]) -> Bool {
    if lhs.count == rhs.count {
        for i in lhs.indices {
            if !(lhs[i] == rhs[i]) {
                return false
            }
        }
        return true
    }
    return false
}

struct Test_Ext_Array_deltasAndRangesWithNewArrays_Float {
    let testName: String
    let array: Array<Float>
    let fromArray: Array<Float>
    let deltaPicker: ([(Range<Int>, Float)]) -> (Range<Int>, Float)?
    let expectedOutcome: (deltas: [Float], ranges: [Range<Int>], newArrays: [[Float]])?
    func test() -> Bool {
        if let outcome = array.deltasAndRangesWithNewArrays(from: fromArray, deltaPicker: deltaPicker) {
            print(outcome)
            if let out = expectedOutcome {
                return outcome.deltas == out.deltas && outcome.ranges == out.ranges && outcome.newArrays == out.newArrays
            }
        }
        else if expectedOutcome == nil {
            return true
        }
        return false
    }
}

let normalTargetArrayFloat: [Float] = [0.00042, 0.00321, 0.00053, 0.00012, 0.00008, 0.02123, 0.00002, 0.12341, 0.00653, 0.00001]
let normalInitialArrayFloat: [Float] = [0.00001, 0.00023, 0.00053, 0.00123, 0.00412, 0.00008, 0.00231, 0.00023, 0.01234, 0.00043, 0.00001, 0.00003]

let normalTargetArray = [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 4]
let normalInitialArray = [1, 23, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3]
let shorterArray = [1]
let longerArray = [Int](count: 15, repeatedValue: 55)

/// No corresponding element in either array.
/// 'from' is shorter.
/// Return 'nil'.
let toTarget0 = normalTargetArray.deltasAndRangesWithNewArrays(from: shorterArray) { $0.first }
print("toTarget0: \(toTarget0)")
/// 'from' is longer.
/// Return 'nil'.
let toTarget1 = normalTargetArray.deltasAndRangesWithNewArrays(from: longerArray) { $0.first }
print("toTarget1: \(toTarget1)")
/// 'deltaPicker' not working properly.
/// Return 'nil'.
let toTarget2 = normalTargetArray.deltasAndRangesWithNewArrays(from: longerArray) { _ in return nil }
print("toTarget2: \(toTarget2)")
/// Normal.
/// Returns '([41, 257, 409, -400, 1892, -21, 610, 10497, 1], [Range(0..<2), Range(1..<2), Range(3..<4), Range(4..<5), Range(6..<7), Range(7..<8), Range(8..<10), Range(8..<9), Range(11..<12)], [[42, 64, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 123, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 412, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 231, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 23, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 1234, 43, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 1844, 653, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 3], [42, 321, 53, 532, 12, 8, 2123, 2, 12341, 653, 1, 4]])'.
let toTarget3 = normalTargetArray.deltasAndRangesWithNewArrays(from: normalInitialArray) { $0.first }
print("toTarget3: \(toTarget3)")
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
