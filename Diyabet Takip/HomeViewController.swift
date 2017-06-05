
import UIKit

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    var seker = [Int]()
    var sekerZaman = [String]()
    var zaman = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var sekerOlcum: UITextField!
    @IBOutlet weak var kalanSeker: UILabel!
    @IBAction func sekerKaydet(_ sender: Any) {
        if (sekerOlcum.text?.characters.count)! > 0{
        zamanTut()
        seker.append(Int(sekerOlcum.text!)!)
        sekerZaman.append(zaman)
        tableView1.reloadData()
        sekerOlcum.text = ""
        kalanSeker.text =  (seker.reduce(0){$0+$1} / seker.count).description}}
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {return seker.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {let cell = UITableViewCell()
        cell.textLabel?.text = sekerZaman[indexPath.item] + " =  " + seker[indexPath.item].description
        return cell}
     func zamanTut(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        var hours = "\(hour):\(minutes):\(seconds)"
        zaman = hours}}
