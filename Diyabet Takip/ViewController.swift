

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
 
    @IBOutlet weak var coreDataTemizle: UIButton!
    @IBAction func coreDataTemizle(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }}
        override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 7
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Users")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            if results.count > 0{
                for result in results as! [NSManagedObject]
                {
                  if let email = result.value(forKey: "email") as? String
                    {
                        emailField.text = email
                        print("****** Kayıtlı email: \(email)")
                    }
                    if let pass = result.value(forKey: "pass") as? String
                    {
                        passField.text = pass
                        print("****** Kayıtlı Şifre: \(pass)")
                        }}}}
        catch{print(error)}
    }
    @IBAction func signInBtn(_ sender: Any) {
        if (emailField != nil && passField != nil )
        {
            loginUser(urlString: "http://localhost:8888/loginDiyabet.php")
        }}
        func loginUser(urlString: String){
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let email = emailField.text
        let pass = passField.text
        let parameters = "email="+email!+"&pass="+pass!
        request.httpBody = parameters.data(using: String.Encoding.utf8)//Türkçe karakter izni veriyoruz.
        if ((email?.isEmpty)!||(pass?.isEmpty)!) {
            print("Hata! Lütfen boş alanları doldurunuz.")
        }
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
                            print(message)
                        DispatchQueue.main.async {  //kayıt olmasını bekleyip sonradan alanları boşaltır
                                //firstview sayfadan home view sayfaya geçiş
                                let form = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                                form.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                                self.present(form, animated: true, completion: nil)
                                
                                //firstview sayfadan home view sayfaya geçiş
                                self.emailField.text = ""
                                self.passField.text = ""
                                }
                            }else{
                            print(message)}}
                    }catch{
                    print(error)}}}
        task.resume()}}

