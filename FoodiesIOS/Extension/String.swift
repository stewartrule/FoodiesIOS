extension String {
    func trim() -> Self {
        trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
}
