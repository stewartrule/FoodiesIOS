import SwiftHttp

extension HttpError {
    var friendlyErrorDescription: String {
        switch self {
            case .invalidResponse: return "Invalid response"
            case .unknownStatusCode: return "Unknown status code"
            case .invalidStatusCode(let response):
                return "Invalid status code: \(response.statusCode.rawValue)"
            case .missingHeader(_): return "Missing header"
            case .invalidHeaderValue(_): return "Invalid header value"
            case .missingUploadData: return "Missing upload data"
            case .unknown(let error): return error.localizedDescription
        }
    }
}
