//
//  ShotLocationRepository.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 22.07.2022.
//

import Foundation

class ShotLocationRepository {

    func fetch() async throws -> [ShotLocation] {
        let url = URL(string: "http://localhost:8080/locations")!

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ShotLocation].self, from: data)
    }

    func create(shotLocation: ShotLocation) {
        let url = URL(string: "http://localhost:8080/locations")!

        do {
            Task {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let data = try JSONEncoder().encode(shotLocation)

                request.setValue(String(data.count), forHTTPHeaderField:"Content-Length")
                request.setValue("application/json", forHTTPHeaderField:"Accept")
                request.setValue("application/json", forHTTPHeaderField:"Content-Type")
                _ = try await URLSession.shared.upload(for: request, from: data)
            }
        } catch {
            print("heh")
        }
    }
}

struct ShotLocation: Codable {
    let title: String
    let description: String
    let coordinatesLon: Double
    let coordinatesLat: Double
}

extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }

    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func upload(for request: URLRequest, from data: Data) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.uploadTask(with: request, from: data) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
