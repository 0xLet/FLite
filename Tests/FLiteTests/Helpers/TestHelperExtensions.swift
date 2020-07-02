internal let shouldLog = false
internal extension String {
    func log() {
        if shouldLog {
            print(self)
        }
    } 
}
