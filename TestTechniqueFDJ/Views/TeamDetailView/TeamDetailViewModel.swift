//
//  SearchViewModel.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 23/06/2023.
//

import Foundation
import Combine

class TeamDetailViewModel: ObservableObject {
    
    @Published var team : Team
    @Published var teamDetail : TeamDetail!
    @Published var isLoading : Bool
    @Published var isError : Bool
    @Published var bannerImageData : Data?
    
    init(team: Team) {
        self.isLoading = true
        self.isError = false
        self.team = team
        fetchTeamDetail()
    }
        
    func fetchTeamDetail(){
        APIManager.shared.searchTeamDetail(for: team, completion: { detail in
            guard let detail = detail else {
                DispatchQueue.main.async {
                    self.isError = true
                    self.isLoading = false
                }
                return
            }
            DispatchQueue.main.async {
                self.teamDetail = detail
                if let strTeamBanner = detail.strTeamBanner {
                    self.loadImageData(fromURL: URL(string: strTeamBanner)!)
                }else{
                    self.isLoading = false
                }
            }
            
        })
    }
    
    func loadImageData(fromURL url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async { [self] in
                if let error = error {
                    print("Erreur lors du chargement des données de l'image :", error)
                    bannerImageData = nil
                } else if let imageData = data {
                    bannerImageData = imageData
                } else {
                    bannerImageData = nil
                }
                self.isLoading = false

            }
        }
        task.resume()
    }
}
