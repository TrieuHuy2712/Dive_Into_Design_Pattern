/// Iterator Design Pattern
///
/// Intent: Lets you traverse elements of a collection without exposing its
/// underlying representation (list, stack, tree, etc.).
///
/// Swift language has a built-in iterator support:
///
/// - The `IteratorProtocol` provides a simple iterator protocol:
/// https://developer.apple.com/documentation/swift/iteratorprotocol
///
/// - The `AnyIterator<Element>` struct provides basic iterator implementation:
/// https://developer.apple.com/documentation/swift/anyiterator
///
/// In this examples we'll see how to use both of these mechanisms.

import XCTest

/// This is a collection that we're going to iterate through using an iterator
/// derived from IteratorProtocol.
class WordsCollection {

    fileprivate lazy var items = [String]()

    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {

    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

/// Concrete Iterators implement various traversal algorithms. These classes
/// store the current traversal position at all times.
class WordsIterator: IteratorProtocol {

    private let collection: WordsCollection
    private var index = 0

    init(_ collection: WordsCollection) {
        self.collection = collection
    }

    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}


/// This is another collection that we'll provide AnyIterator for traversing its
/// items.
class NumbersCollection {

    fileprivate lazy var items = [Int]()

    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {

    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1

        return AnyIterator {
            defer { index -= 1 }
            return index >= 0 ? self.items[index] : nil
        }
    }
}

/// Client does not know the internal representation of a given sequence.
class Client {
    // ...
    static func clientCode<S: Sequence>(sequence: S) {
        for item in sequence {
            print(item)
        }
    }
    // ...
}

/// Let's see how it all works together.
class IteratorConceptual: XCTestCase {

    func testIteratorProtocol() {

        let words = WordsCollection()
        words.append("First")
        words.append("Second")
        words.append("Third")

        print("Straight traversal using IteratorProtocol:")
        Client.clientCode(sequence: words)
    }

    func testAnyIterator() {

        let numbers = NumbersCollection()
        numbers.append(1)
        numbers.append(2)
        numbers.append(3)

        print("\nReverse traversal using AnyIterator:")
        Client.clientCode(sequence: numbers)
    }
}
