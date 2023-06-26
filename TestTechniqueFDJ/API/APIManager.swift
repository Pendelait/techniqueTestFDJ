//
//  APIManager.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 23/06/2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    private let apiKey = "50130162"
    private let baseURL = "https://www.thesportsdb.com/api/v1/json/"

    func searchAllLeagues(completion: @escaping ([League]) -> Void) {
        let endpoint = "\(baseURL)\(apiKey)/all_leagues.php"

        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            

            do {
                let response = try JSONDecoder().decode(LeaguesResponse.self, from: data)
                completion(response.leagues)
            } catch {
                print(error)
                completion([])
            }
        }.resume()
    }
    
    func searchAllTeams(for league : League , completion: @escaping ([Team]) -> Void) {
        let endpoint = "\(baseURL)\(apiKey)/search_all_teams.php?l=\(league.strLeague.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            

            do {
                let response = try JSONDecoder().decode(TeamsResponse.self, from: data)
                completion(response.teams)
            } catch {
                print(error)
                completion([])
            }
        }.resume()
    }
    
    func searchTeamDetail(for team : Team , completion: @escaping (TeamDetail?) -> Void) {
        let endpoint = "\(baseURL)\(apiKey)/searchteams.php?t=\(team.strTeam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            

            do {
                let response = try JSONDecoder().decode(TeamDetailResponse.self, from: data)
                completion(response.teams.first!)
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}

struct LeaguesResponse: Codable {
    let leagues: [League]
}

struct TeamsResponse: Codable {
    let teams: [Team]
}

struct TeamDetailResponse: Codable {
    let teams: [TeamDetail]
}


