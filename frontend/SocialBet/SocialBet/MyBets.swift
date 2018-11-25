//
//  MyBets.swift
//  SocialBet
//
//  Created by Alex Chapp on 11/8/18.
//  Copyright © 2018 Nick Cargill. All rights reserved.
//

import UIKit

class MyBets: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.feedCount = 0;
        
        self.MyFeed.register(UINib(nibName: "LiveFeedCell", bundle:nil), forCellWithReuseIdentifier: "LiveFeedCell");
        self.MyFeed.register(UINib(nibName: "OpenFeedCell", bundle:nil), forCellWithReuseIdentifier: "OpenFeedCell");
        self.MyFeed.register(UINib(nibName: "ClosedFeedCell", bundle:nil), forCellWithReuseIdentifier: "ClosedFeedCell");
        
        self.MyFeed.delegate = self
        self.MyFeed.dataSource = self
        
        Live(self)
    }
    
    enum FeedTypes{
        case live
        case open
        case result
        case request
    }
    
    
    @IBOutlet weak var ResultsObject: UIButton!
    @IBOutlet weak var RequestsObject: UIButton!
    @IBOutlet weak var OpenObject: UIButton!
    @IBOutlet weak var LiveObject: UIButton!
    
    var feedCount: Int?;
    var feedType = FeedTypes.live;
    var liveData: BetFeed?;
    var openData: BetFeed?;
    var requestData: BetFeed?;
    var resultData: BetFeed?;
    var current_bet_id: String?;
    
    
    @IBAction func notificationsToHome() {
        performSegue(withIdentifier: "NotificationsToHome", sender: self)
    }
    
    @IBAction func Live(_ sender: Any) {
        let fullURI = addGETParams(path: "/api/feeds/users_live_bets/", search: "", needsUsername: false)
        sendGET(uri: fullURI, callback: { (httpresponse) in
            let data: Data! = httpresponse.data
            
            guard let feedData = try? JSONDecoder().decode(BetFeed.self, from: data)
                else {
                    self.alert(message: "There was an error while decoding the response.", title: "Malformed Response Error")
                    return
            }
            self.liveData = feedData;
            self.feedCount = self.liveData!.bets.count;
            self.LiveObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17);
            self.OpenObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.ResultsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.RequestsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.feedType = .live
            self.MyFeed.reloadData()
        })
        
        
    }
    
    @IBAction func Open(_ sender: Any) {
        let fullURI = addGETParams(path: "/api/feeds/users_open_bets/", search: "", needsUsername: false)
        sendGET(uri: fullURI, callback: { (httpresponse) in
            let data: Data! = httpresponse.data
            
            guard let feedData = try? JSONDecoder().decode(BetFeed.self, from: data)
                else {
                    self.alert(message: "There was an error while decoding the response.", title: "Malformed Response Error")
                    return
            }
            self.openData = feedData;
            self.feedCount = self.openData!.bets.count;
            self.OpenObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17);
            self.LiveObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.ResultsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.RequestsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.feedType = .open
            self.MyFeed.reloadData()
        })
        
        
    }
    
    @IBAction func Requests(_ sender: Any) {
        let fullURI = addGETParams(path: "/api/feeds/direct_bets_pending/", search: "", needsUsername: false)
        sendGET(uri: fullURI, callback: { (httpresponse) in
            let data: Data! = httpresponse.data
            
            guard let feedData = try? JSONDecoder().decode(BetFeed.self, from: data)
                else {
                    self.alert(message: "There was an error while decoding the response.", title: "Malformed Response Error")
                    return
            }
            self.requestData = feedData;
            self.feedCount = self.requestData!.bets.count;
            self.RequestsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17);
            self.OpenObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.ResultsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.LiveObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.feedType = .request
            self.MyFeed.reloadData()
        })
        
        
    }
    
    @IBAction func Results(_ sender: Any) {
        let fullURI = addGETParams(path: "/api/feeds/bet_history/", search: "", needsUsername: false)
        sendGET(uri: fullURI, callback: { (httpresponse) in
            let data: Data! = httpresponse.data
            
            guard let feedData = try? JSONDecoder().decode(BetFeed.self, from: data)
                else {
                    self.alert(message: "There was an error while decoding the response.", title: "Malformed Response Error")
                    return
            }
            self.resultData = feedData;
            self.feedCount = self.resultData!.bets.count;
            self.ResultsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17);
            self.OpenObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.LiveObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.RequestsObject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            self.feedType = .result
            self.MyFeed.reloadData()
        })
        
        
    }
    
    @IBOutlet weak var MyFeed: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.feedType {
            
        case .live:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveFeedCell", for: indexPath) as? LiveFeedCell;
            
            let thisBet = self.liveData!.bets[indexPath.row];
            
            cell?.User1Name.text = thisBet.user1.first_name + " " + thisBet.user1.last_name;
            cell?.User2Name.text = thisBet.user2!.first_name + " " + thisBet.user2!.last_name;
            getImageFromUrl(urlString: thisBet.user1.profile_pic_url, imageView: (cell?.User1Image)!);
            getImageFromUrl(urlString: thisBet.user2!.profile_pic_url, imageView: (cell?.User2Image)!);
            
            cell?.TeamName1.text = thisBet.user1.team;
            cell?.TeamName2.text = thisBet.user2!.team;
            cell?.Message.text = thisBet.message;
            cell?.GameTime.text = thisBet.game_time;
            cell?.WagerAmount.text = "Amount: $" + String(thisBet.ammount);
            
            let user1Team = teamURL(teamname: thisBet.user1.team);
            let user2Team = teamURL(teamname: thisBet.user2!.team);
            
            getImageFromUrl(urlString: user1Team, imageView: (cell?.Team1Image)!);
            getImageFromUrl(urlString: user2Team, imageView: (cell?.Team2Image)!);
            
            cell?.AcceptButton.setImage(nil, for: .normal)
            cell?.DeclineButton.setImage(nil, for: .normal)
            cell?.AcceptButton.isEnabled = false;
            cell?.AcceptButton.isEnabled = false;
            
            
            return cell!;
            
        case .open:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenFeedCell", for: indexPath) as? OpenFeedCell;
            
            let thisBet = self.openData!.bets[indexPath.row];
            
            cell?.UserName.text = thisBet.user1.first_name + " " + thisBet.user1.last_name;
            cell?.UserTeamName.text = thisBet.user1.team;
            cell?.UserTeamLowerText.text = thisBet.user1.team;
            cell?.OtherTeamLowerText.text = thisBet.team2;
            cell?.BetAmount.text = "Amount: $" + String(thisBet.ammount);
            cell?.GameTime.text = thisBet.game_time;
            
            getImageFromUrl(urlString: teamURL(teamname: thisBet.team1), imageView: (cell?.UserTeamLogo)!);
            getImageFromUrl(urlString: teamURL(teamname: thisBet.team2), imageView: (cell?.OtherTeamLogo)!);
            
            return cell!;
            
        case .result:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosedFeedCell", for: indexPath) as? ClosedFeedCell;
            
            let thisBet = self.resultData!.bets[indexPath.row];
            
            //let winner = thisBet.winner!;
            //let user1 = thisBet.user1;
            //let user2 = thisBet.user2!;
            
            let betResults = findResults(winner: thisBet.winner!, user1: thisBet.user1, user2: thisBet.user2!);
            
            getImageFromUrl(urlString: betResults.winner.profile_pic_url, imageView: (cell?.WinningUserPic)!)
            getImageFromUrl(urlString: betResults.loser.profile_pic_url, imageView: (cell?.LosingUserPic)!)
            cell?.WinningUserName.text = betResults.winner.username;
            cell?.LosingUserName.text = betResults.loser.username;
            
            cell?.WinningTeamName.text = betResults.winner.team;
            cell?.LosingTeamName.text = betResults.loser.team;
            cell?.GameDateTime.text = thisBet.game_time;
            cell?.WagerAmount.text = String(describing: thisBet.ammount);
            
            let winningTeamUrl = teamURL(teamname: betResults.winner.team);
            let losingTeamUrl = teamURL(teamname: betResults.loser.team);
            
            getImageFromUrl(urlString: winningTeamUrl, imageView: (cell?.WinningTeamLogo)!)
            getImageFromUrl(urlString: losingTeamUrl, imageView: (cell?.LosingTeamLogo)!)
            
            return cell!;
            
        case .request:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveFeedCell", for: indexPath) as? LiveFeedCell;
            
            let thisBet = self.requestData!.bets[indexPath.row];
            
            cell?.User1Name.text = thisBet.user1.first_name + " " + thisBet.user1.last_name;
            cell?.User2Name.text = thisBet.user2!.first_name + " " + thisBet.user2!.last_name;
            getImageFromUrl(urlString: thisBet.user1.profile_pic_url, imageView: (cell?.User1Image)!);
            getImageFromUrl(urlString: thisBet.user2!.profile_pic_url, imageView: (cell?.User2Image)!);
            cell?.TeamName1.text = thisBet.user1.team;
            cell?.TeamName2.text = thisBet.user2!.team;
            cell?.Message.text = thisBet.message;
            cell?.GameTime.text = thisBet.game_time;
            cell?.WagerAmount.text = "Amount: $" + String(thisBet.ammount);
            cell?.bet_id = thisBet.bet_id;
            
            let team1Url = teamURL(teamname: thisBet.user1.team);
            let team2Url = teamURL(teamname: thisBet.user2!.team);
            
            getImageFromUrl(urlString: team1Url, imageView: (cell?.Team1Image)!);
            getImageFromUrl(urlString: team2Url, imageView: (cell?.Team2Image)!);
            
            
            cell?.AcceptButton.setImage(UIImage(named: "accept.png"), for: .normal)
            cell?.DeclineButton.setImage(UIImage(named: "decline.png"), for: .normal)
            
            cell?.AcceptButton.isEnabled = true;
            cell?.DeclineButton.isEnabled = true;
            
            return cell!;
        }
    }

    func AcceptButtonPressed(bet_id: Int) {
        let parameters = ["loguser": common.username, "auth": common.pwhash, "bet_id": bet_id as Any] as Dictionary<String, Any>;
        
        sendPOST(uri: "/api/betting/accept_bet", parameters: parameters, callback: { (postresponse) in
            if postresponse["success_status"] as! String == "successful" {
                self.alert(message: "You have accepted the bet!", title: "Bet Accepted");
            } else {
                self.alert(message: "Bet unable to be accepted", title: "Bet Acceptance Error")
            }
        })
    }
    
    func DeclineButtonPressed(bet_id: Int) {
        let parameters = ["loguser": common.username, "auth": common.pwhash, "bet_id": bet_id as Any] as Dictionary<String, Any>;
        
        sendPOST(uri: "/api/betting/cancel_bet", parameters: parameters,
            callback: { (postresponse) in
            if postresponse["success_status"] as! String == "successful" {
                self.alert(message: "You have declined the bet!", title: "Bet Declined");
            } else {
                self.alert(message: "Bet unable to be declined", title: "Bet Decline Error")
            }
        })
    }
}

extension MyBets: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 160)
    }
    
}
