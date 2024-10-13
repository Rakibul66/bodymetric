import Foundation

// Model for BMI Response
struct BMIResponse: Codable {
    let bmi: Double
    let weight: String
    let height: String
    let weightCategory: String
}

class BMIService {
    
    private let apiKey = "8ec235d2f6mshbffe97c67b86260p1a6cb8jsna608fd681823"
    private let apiHost = "body-mass-index-bmi-calculator.p.rapidapi.com"
    
    func fetchBMI(weight: Double, height: Double, completion: @escaping (Result<BMIResponse, Error>) -> Void) {
        
        // Construct URL
        guard let url = URL(string: "https://\(apiHost)/metric?weight=\(weight)&height=\(height)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(apiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        // Network call
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse JSON
            do {
                let decoder = JSONDecoder()
                let bmiResponse = try decoder.decode(BMIResponse.self, from: data)
                completion(.success(bmiResponse))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }
}
