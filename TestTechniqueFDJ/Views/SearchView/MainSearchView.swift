//
//  ContentView.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 23/06/2023.
//

import SwiftUI

struct MainSearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismissSearch) var dismissSearch
    

    var body: some View {
        NavigationStack {
            SearchView(viewModel: viewModel)
            .navigationDestination(isPresented: $viewModel.showTeamDetail) {
                if viewModel.showTeamDetail {
                    if let selectedTeam = viewModel.selectedTeam {
                        TeamView(team: selectedTeam)
                    }
                }
          }
            
            

        }
        .searchable(text: $viewModel.searchText,prompt: "Search by league")
        
        
    }
}

struct SearchView: View {
    @ObservedObject var viewModel : SearchViewModel
    @Environment(\.isSearching) var isSearching

    var body : some View {
        ZStack{
            if viewModel.showTeam{
                TeamListView(viewModel: viewModel)
            }else{
                LeagueSearchListView(viewModel: viewModel)
            }
        }.onChange(of: isSearching) { newValue in
            if !newValue {
                viewModel.searchText = ""
                viewModel.filteredLeagues.removeAll()
                viewModel.teamsOfSelectedLeague.removeAll()
                viewModel.showTeam = false
            }
        }
    }
}

struct LeagueSearchListView : View {
    @ObservedObject var viewModel : SearchViewModel
    var body : some View {
        List(viewModel.filteredLeagues, id: \.strLeague) { league in
            ZStack{
                Text("\(league.strLeague)")
                    
            }.onTapGesture {
                viewModel.didSelectLeague(league)
                UIApplication.shared.endEditing()
            }
            
        }
    }
}

struct TeamListView : View {
    @ObservedObject var viewModel : SearchViewModel
    var body : some View {
        List{
            ForEach(Array(viewModel.sortedTeamsList.enumerated()), id: \.element) { index,teamPair in
                HStack{
                    ForEach(teamPair, id: \.strTeam ){ team in
                        Spacer()
                        TeamBadgeImageView(strUrl: team.strTeamBadge)
                            .onTapGesture {
                                viewModel.selectedTeam = team
                                viewModel.showTeamDetail = true
                            }
                        if viewModel.sortedTeamsList[index].count != 2 {
                            Spacer()
                            TeamBadgeImageView(strUrl: nil)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}


struct TeamBadgeImageView: View {
    let strUrl: String?
    
    init(strUrl: String?) {
        self.strUrl = strUrl
    }
    
    var body: some View {
        if let strUrl = strUrl{
            AsyncImage(url: URL(string: strUrl )) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
            } placeholder: {
                Color.gray
                    .frame(width: 120, height: 120)
            }.frame(width: 120,height: 120)
        }else{
            Circle()
                .frame(width: 120, height: 120) // Définir la taille du cercle
                .hidden()
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainSearchView()
    }
}


