//
//  BetBuilderGameSelection.swift
//  SocialBet
//

import UIKit

class BetBuilderGameSelection: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedOpponent: String?;
    var selectedGame: Int?;
    @IBOutlet weak var BuilderGamesFeed: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.BuilderGamesFeed.register(UINib(nibName: "GamesFeedCell", bundle:nil), forCellWithReuseIdentifier: "GamesFeedCell");

        // Do any additional setup after loading the view.
        print("Opponent Handle: " + self.selectedOpponent!);
        
    }
    
    //Use this function to pass data through segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("Override Works!");
        //if going to next stage of bet builder
        if let vc = segue.destination as? BetBuilderTeamSelection{
            vc.selected_game_id = self.selectedGame;
            vc.selected_opponent = self.selectedOpponent;
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         /*
         let data: Data = Data(); //TODO - Load the correct data with API call for games feed
         guard let feed = try? JSONDecoder().decode(GamesFeed.self, from: data)
         else {
         print("Error decoding data");
         return 0;
         }
         return feed.games.count;
         */
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesFeedCell", for: indexPath) as? GamesFeedCell;
            
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        //TODO - store the selected event_ID and bring up next screen with that game loaded
        if let indexPath = self.BuilderGamesFeed.indexPathsForSelectedItems?.first{
            let cell = self.BuilderGamesFeed.cellForItem(at: indexPath) as? GamesFeedCell;
            self.selectedGame = cell?.event_id;
            performSegue(withIdentifier: "GameSelectToTeamSelect", sender: self);
        }
        
    }
    
    
    
    

}
