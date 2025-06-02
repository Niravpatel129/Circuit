import Foundation

class NFTService: ObservableObject {
    @Published var isVerifying = false
    @Published var verificationStatus: String = "Not Verified"
    
    func verifyNFTOwnership(nfcPayload: String) async throws -> Bool {
        // TODO: Replace with actual NFT API endpoint
        let apiEndpoint = "https://api.example.com/verify-nft"
        
        guard let url = URL(string: apiEndpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["nfc_payload": nfcPayload]
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let verificationResponse = try JSONDecoder().decode(VerificationResponse.self, from: data)
        return verificationResponse.isValid
    }
}

struct VerificationResponse: Codable {
    let isValid: Bool
    let message: String
} 
