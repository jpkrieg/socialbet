//
//  Registration.swift
//  SocialBet
//


import UIKit

class Registration: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var RegistrationUsername: UITextField!
    @IBOutlet weak var RegistrationPassword: UITextField!
    @IBOutlet weak var RegistrationConfirmPassword: UITextField!
    @IBOutlet weak var RegistrationPhoneNumber: UITextField!
    @IBOutlet weak var RegistrationFirstName: UITextField!
    @IBOutlet weak var RegistrationLastName: UITextField!
    
    @IBAction func RegistrationSubmit(_ sender: Any) {
        let username = RegistrationUsername.text;
        let password = RegistrationPassword.text;
        let confirmPassword = RegistrationConfirmPassword.text;
        let phoneNumber = RegistrationPhoneNumber.text;
        let firstName = RegistrationFirstName.text;
        let lastName = RegistrationLastName.text;
        
        if (password != confirmPassword){
            self.alert(message: "The password and ConfirmPassword fields must match", title: "Registration Error")
            return;
        }
        
        let auth = sha256(data: (password!).data(using: String.Encoding.utf8)! as NSData);
        
        let parameters = ["username": username, "auth": auth, "phoneNumber": phoneNumber, "firstName": firstName, "lastName": lastName, "profile_pic_url": common.default_pic] as! Dictionary<String, String>
        
        // create and send a POST request
        let response = sendPOST(uri: "/api/users/create/", parameters: parameters)
        
        // alert the user of success/failure, and either navigate away or refresh the page
        if response.error == nil {
            // TODO: error isn't being handled properly, figure out
            performSegue(withIdentifier: "RegistrationToLiveFeed", sender: self);
        }
        else{
            // TODO: check HTML error codes
            self.alert(message: "Error creating account. Try again.", title: "Account Creation Error")
            viewDidLoad()
        }
        
    }
    
     @IBAction func GoToLogin(_ sender: Any) {
        performSegue(withIdentifier: "RegistrationToLogin", sender: self)
     }
    
    @IBAction func GoToHelp(_ sender: Any) {
        //TODO - Rip this out...just here for testing views
        performSegue(withIdentifier: "FakeRegToProf", sender: self);
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
