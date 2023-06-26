//
//  SearchViewModel.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 23/06/2023.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
        @Published var filteredLeagues: [League] = []
        @Published var teamsOfSelectedLeague: [Team] = []
        @Published var sortedTeamsList : [[Team]] = []
        @Published var searchText : String = ""
        @Published var showTeam : Bool = false
        @Published var showTeamDetail : Bool = false
        
        private var leagues: [League] = []
        private var cancellables = Set<AnyCancellable>()
    
        @Published var selectedTeam : Team?

        init() {
            setupListeners()
            fetchLeague()
        }
    
        private func setupListeners() {
            $searchText
                .sink { [self] newValue in
                    if showTeam{
                        showTeam = false
                        teamsOfSelectedLeague.removeAll()
                    }
                    searchLeagues(with: newValue)
                }
                .store(in: &cancellables)
        }
        
        func fetchLeague(){
            APIManager.shared.searchAllLeagues(completion: { leagues in
                DispatchQueue.main.async {
                    self.leagues = leagues
                }
            })
        }
    
        func fetchTeams(for league: League){
            APIManager.shared.searchAllTeams(for: league, completion: { teams in
                DispatchQueue.main.async {
                    self.teamsOfSelectedLeague = teams
                    self.sortTeamList()
                    self.showTeam = true
                }
            })
        }
        
        func searchLeagues(with searchText: String) {
            filteredLeagues = leagues.filter { $0.strLeague.lowercased().contains(searchText.lowercased()) }
        }
    
        func didSelectLeague(_ league : League){
            searchText = league.strLeague
            fetchTeams(for: league)
        }
    
        func sortTeamList(){
            let filteredTeamList = teamsOfSelectedLeague.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
            let sortedTeamsList = (filteredTeamList.sorted { $0.strTeam > $1.strTeam }).chunked(into: 2)
            self.sortedTeamsList = sortedTeamsList
        }
}
