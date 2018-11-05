//
//  LiveFeed.swift
//  SocialBet
//
//  Created by Alex Chapp on 10/28/18.
//  Copyright © 2018 Nick Cargill. All rights reserved.
//

import UIKit
import Foundation

struct LiveBetFeed: Decodable {
    let bets: [LiveBet]
}

struct OpenBetFeed: Decodable {
    let bets: [OpenBet]
}

struct GamesFeed: Decodable {
    let games: [Game]
}

struct LiveBet: Decodable {
    let bet_id: String
    let time_placed: String
    let game_time: String
    let num_comments: Int
    let num_likes: Int
    let message: String
    let user1: User
    let user2: User
}

struct OpenBet: Decodable {
    let bet_id: String
    let time_made: String
    let game_time: String
    let num_comments: Int
    let num_likes: Int
    let message: String
    let amount: Int
    let user: User
    let other_team: String
    let other_team_logo_url: String
}

struct Game: Decodable {
    let date: String
    let games: [InnerGame]
}

struct User: Decodable {
    let user_id: Int
    let first_name: String
    let last_name: String
    let profile_pic_url: String
    let team: String
    let team_logo_url: String
}

struct InnerGame: Decodable {
    let event_id: Int
    let home_team: Team
    let away_team: Team
}

struct Team: Decodable {
    let name: String
    let wins: Int
    let losses: Int
    let team_logo_url: String
}

enum FeedTypes{
    case live
    case open
    case games
}

var feedType = FeedTypes.live;

func getImageFromUrl(urlString: String) -> UIImage {
    var image: UIImage = UIImage();
    let url:URL = URL(string: urlString)!;
    DispatchQueue.global(qos: .userInitiated).async {
        if let data:NSData = try? NSData(contentsOf: url){
            DispatchQueue.main.async {
                image = UIImage(data: data as Data)!;
            }
        }
        else{
            print("Error loading images");
        }
    }
    
    return image;
}

class LiveFeed: UIViewController {
    
    @IBOutlet weak var TopBar: UIView!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var LiveBetsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        ProfilePic.layer.cornerRadius = ProfilePic.frame.size.width / 2;
        ProfilePic.clipsToBounds = true;
        
        loadProfileInfo();
        // Do any additional setup after loading the view.
        ProfilePic.image = UIImage(named: "");
    }
    
    @IBAction func GamesButton(_ sender: Any) {
        feedType = .games;
        self.LiveBetsCollection.reloadData();
    }
    
    @IBAction func OpenBetsButton(_ sender: Any) {
        feedType = .open;
        self.LiveBetsCollection.reloadData();
    }
    
    @IBAction func LiveBetsButton(_ sender: Any) {
        feedType = .live;
        self.LiveBetsCollection.reloadData();
    }
    
    func loadProfileInfo() {
        //TODO - Get the info for this user and use
        //it to populate the profile pic and events
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch feedType {
        case .live:
            let data: Data = Data(); //TODO - Load the correct data with API call for live feed
            guard let feed = try? JSONDecoder().decode(LiveBetFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return 0;
            }
            return feed.bets.count;
            
            
        case .open:
            let data: Data = Data(); //TODO - Load the correct data with API call for open feed
            guard let feed = try? JSONDecoder().decode(OpenBetFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return 0;
            }
            return feed.bets.count;
            
        case .games:
            let data: Data = Data(); //TODO - Load the correct data with API call for games feed
            guard let feed = try? JSONDecoder().decode(GamesFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return 0;
            }
            return feed.games.count;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch feedType {
            
        case .live:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCell", for: indexPath) as? LiveFeedCell;
            
            let data: Data = Data(); //TODO - Load the correct data with API call
            guard let feed = try? JSONDecoder().decode(LiveBetFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return cell!;
            }
            
            let thisBet = feed.bets[indexPath.row];
            
            cell?.User1Name.text = thisBet.user1.first_name + " " + thisBet.user1.last_name;
            cell?.User2Name.text = thisBet.user2.first_name + " " + thisBet.user2.last_name;
            cell?.User1Image.image = getImageFromUrl(urlString: thisBet.user1.profile_pic_url);
            cell?.User2Image.image = getImageFromUrl(urlString: thisBet.user2.profile_pic_url);
            cell?.Team1Image.image = getImageFromUrl(urlString: thisBet.user1.team_logo_url);
            cell?.Team2Image.image = getImageFromUrl(urlString: thisBet.user2.team_logo_url);
            cell?.TeamName1.text = thisBet.user1.team;
            cell?.TeamName2.text = thisBet.user2.team;
            cell?.Message.text = thisBet.message;
            cell?.GameTime.text = thisBet.game_time;
            cell?.BetTime.text = thisBet.time_placed;
            
            return cell!;
            
        case .open:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenCell", for: indexPath) as? OpenFeedCell;
            
            let data: Data = Data(); //TODO - Load the correct data with API call
            guard let feed = try? JSONDecoder().decode(OpenBetFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return cell!;
            }
            
            let thisBet = feed.bets[indexPath.row];
            
            cell?.UserName.text = thisBet.user.first_name + " " + thisBet.user.last_name;
            cell?.UserTeamName.text = thisBet.user.team;
            cell?.UserTeamLogo.image = getImageFromUrl(urlString: thisBet.user.team_logo_url);
            cell?.UserTeamLowerText.text = thisBet.user.team;
            cell?.OtherTeamLogo.image = getImageFromUrl(urlString: thisBet.other_team_logo_url);
            cell?.OtherTeamLowerText.text = thisBet.other_team;
            cell?.BetAmount.text = "Amount: $" + String(thisBet.amount);
            cell?.GameTime.text = thisBet.game_time;
            
            return cell!;
            
        case .games:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCell", for: indexPath) as? GamesFeedCell;
            
            let data: Data = Data(); //TODO - Load the correct data with API call
            guard let feed = try? JSONDecoder().decode(GamesFeed.self, from: data)
                else {
                    print("Error decoding data");
                    return cell!;
            }
            
            //TODO - Figure out how to correctly use this indexPath thing for nested arrays
            
            let theseGames = feed.games[indexPath.row];
            let thisGame = theseGames.games[indexPath.item];
            
            cell?.HomeTeamLogo.image = getImageFromUrl(urlString: thisGame.home_team.team_logo_url);
            cell?.AwayTeamLogo.image = getImageFromUrl(urlString: thisGame.away_team.team_logo_url);
            cell?.HomeTeamName.text = thisGame.home_team.name;
            cell?.AwayTeamName.text = thisGame.away_team.name;
            cell?.HomeTeamRecord.text = String(thisGame.home_team.wins) + "-" + String(thisGame.home_team.losses);
            cell?.AwayTeamRecord.text = String(thisGame.away_team.wins) + "-" + String(thisGame.away_team.losses);
            
            return cell!;
        }
        
        
        
        
    }
}



