extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Sequence {
    func asyncMap<T>(_ map: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for value in self { try await values.append(map(value)) }
        return values
    }
}
