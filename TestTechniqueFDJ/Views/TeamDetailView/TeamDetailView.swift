//
//  TeamView.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 24/06/2023.
//

import SwiftUI

struct TeamView: View {
    @StateObject var viewModel : TeamDetailViewModel
    
    init(team: Team) {
        let viewModel = TeamDetailViewModel(team: team)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            if viewModel.isLoading == false{
                TeamDetailView(viewModel: viewModel)
            }
            if viewModel.isLoading == true {
                LoadingView()
            }
        }
        
    }
}

struct TeamDetailView : View {
    @ObservedObject var viewModel : TeamDetailViewModel
    var body : some View {
        ZStack{
            GeometryReader { geometry in
                VStack{
                    
                    if let data = viewModel.bannerImageData, let uiImage = UIImage(data:data) {
                        // Convertir l'UIImage en SwiftUI Image
                        let image = Image(uiImage: uiImage)
                        
                        // Afficher l'image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width)

                    }else{

                        Text("Bannière introuvable")
                    }
                    ScrollView(.vertical){
                        VStack(alignment: .leading, spacing: 5){
                            Text(viewModel.teamDetail.strCountry ?? "No Country")
                                .padding(5)
                                
                            Text(viewModel.teamDetail.strLeague )
                                .fontWeight(.bold)
                                .padding(5)
                            Text(viewModel.teamDetail.strDescriptionFR ?? "Description Non disponible en Français")
                                .padding(5)
                        }
                        
                    }
                    Spacer()
                }
            }.navigationBarTitle(viewModel.teamDetail.strTeam)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LoadingView: View {
    
    var body: some View {
        ProgressView()
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        Text("lol")
    }
}
