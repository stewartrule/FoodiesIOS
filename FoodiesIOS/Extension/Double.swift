extension Double {
    func toFixed(_ precision: Int) -> String {
        return String(format: "%.\(precision)f", self)
    }
}
