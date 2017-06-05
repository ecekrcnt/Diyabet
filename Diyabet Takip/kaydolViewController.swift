
import UIKit
import CoreData

class kaydolViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passAgainField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func signUpBtn(_ sender: Any) {
        
    registerUser(urlString: "http://localhost:8888/kaydetDiyabet.php")
    }

    func registerUser(urlString: String){
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let name = nameField.text
        let lastName = lastNameField.text
        let email = emailFiled.text
        let pass = passField.text
        let passAgain = passAgainField.text
        let parameters = "name=" + name! + "&lastName=" + lastName! + "&email=" + email! + "&pass=" + pass!
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        if (pass != passAgain)
        {
        alarm(title: "Dikkat!", message: "Girilen şifreler uyuşmamaktadır.")
            }
        if (name?.isEmpty)!||(lastName?.isEmpty)!||(email?.isEmpty)!||(pass?.isEmpty)!||(passAgain?.isEmpty)!{
            alarm(title: "Dikkat", message: "Boş alan bırakmayınız.")}
        let task = URLSession.shared.dataTask(with:request as URLRequest){(data, response, error) in
            if error != nil{//Hata boş değilse, HATA VARSA
                print(error!)
            }else{
                do{
                  let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //jsonu parse ediyoruz
                    if let JsonParse = json{ //json geri dönen mesajı parçalayıp ekrana veriyoruz
                        var message:String!
                        var status:String!
                        message = JsonParse["mesaj"] as! String?
                        status = JsonParse["durum"] as! String?
                        if(status == "basarili"){
                            print("**********Mysql mesajı: \(message)")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                            newUser.setValue(email, forKey: "email")
                            newUser.setValue(pass, forKey: "pass")
                            do{
                                try context.save()
                                print("************* TEBRİKLER CORE DATA KAYDI BAŞARILI **********")
                            }
                            catch
                            {
                                print(error)}
                            DispatchQueue.main.async {  //kayıt olmasını bekleyip sonradan alanları boşaltır
                                self.emailFiled.text = ""
                                self.passField.text = ""
                                self.passAgainField.text = ""
                                let form = self.storyboard!.instantiateViewController(withIdentifier: "ProfilVC") as! profilViewController
                                form.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                                self.present(form, animated: true, completion: nil)}
                            }else{
                            print(message)}}}catch{
                    print(error)}}}
        task.resume()}
       func alarm(title: String,message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "TAMAM", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)}}
