import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var countLabel: UILabel!
    var inputTextField: UITextField?
    var wishList = [String]()
    var number = [Int]()
    var trueWishes:Int = 0
    var totalWishes:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        myTableView.allowsMultipleSelection = true
        myTableView.reloadData()
        //　ナビゲーションバーの背景色
        self.navigationController?.navigationBar.barTintColor = .black
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "wishLists") != nil && UserDefaults.standard.object(forKey: "IDs") != nil{
            wishList = UserDefaults.standard.object(forKey: "wishLists") as! [String]
            number = UserDefaults.standard.object(forKey: "IDs") as! [Int]
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        
        let wish = wishList[indexPath.row]
        let numb = number[indexPath.row]
        cell.wishText?.text = wish
        cell.numberLabel?.text = "#" + String(numb)
        
        if numb % 5 == 1{
            cell.backImage?.image = UIImage(named: "P1.png")
        } else if numb % 5 == 2{
            cell.backImage?.image = UIImage(named: "P2.png")
        } else if numb % 5 == 3{
            cell.backImage?.image = UIImage(named: "P3.png")
        } else if numb % 5 == 4{
            cell.backImage?.image = UIImage(named: "P4.png")
        } else if numb % 5 == 5{
            cell.backImage?.image = UIImage(named: "P5.png")
        } else {
            cell.backImage?.image = UIImage(named: "P5.png")
        }
        
        return cell
    }
    
    @IBAction func post(){
        
        //alertの表示文言
        let alertController: UIAlertController = UIAlertController(title: "あなたのやりたいことは？", message: "こっそり教えてください ;)", preferredStyle: .alert)
        
        //キャンセルボタンを押す
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
            // キャンセルを押した時の処理
        }
        alertController.addAction(cancelAction)
        
        let addAction: UIAlertAction = UIAlertAction(title: "追加", style: .default) { action -> Void in
            
           
            let test = self.inputTextField?.text
            
            self.wishList.append(test!)
            self.number.append(self.number.count)
            
            UserDefaults.standard.set(self.wishList, forKey: "wishLists")
            UserDefaults.standard.set(self.number, forKey: "IDs")
            
            UserDefaults.standard.synchronize()
            
            self.wishList = UserDefaults.standard.object(forKey: "wishLists") as! [String]
            self.number = UserDefaults.standard.object(forKey: "IDs") as! [Int]
            
            self.totalWishes = self.totalWishes + 1
            UserDefaults.standard.set(self.totalWishes, forKey: "total")
            self.totalWishes = UserDefaults.standard.object(forKey: "total") as! Int
            
            self.countLabel.text = String(self.trueWishes) + "/" + String(self.totalWishes)
            
            self.myTableView.reloadData()
            UserDefaults.standard.synchronize()
        }
        
        alertController.addAction(addAction)
        
        alertController.addTextField { textField -> Void in
            self.inputTextField = textField
            textField.placeholder = "叶えたいことを入力しよう！"
        }
        present(alertController, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        myTableView.deselectRow(at: indexPath, animated: true)
        
        let cell = myTableView.cellForRow(at:indexPath)
        
        if cell?.accessoryType == .checkmark {
            // チェックマークを外す
            cell?.accessoryType = .none
            
            self.trueWishes = self.trueWishes - 1
            UserDefaults.standard.set(self.trueWishes, forKey: "true")
            self.trueWishes = UserDefaults.standard.object(forKey: "true") as! Int
            self.countLabel.text = String(self.trueWishes) + "/" + String(self.totalWishes)
            
        } else {
            // チェックマyークを入れる
            cell?.accessoryType = .checkmark

            self.trueWishes = self.trueWishes + 1
            UserDefaults.standard.set(self.trueWishes, forKey: "true")
            self.trueWishes = UserDefaults.standard.object(forKey: "true") as! Int
            self.countLabel.text = String(self.trueWishes) + "/" + String(self.totalWishes)
       
        }
        self.myTableView.reloadData()
        UserDefaults.standard.synchronize()
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            
            self.wishList.remove(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            self.totalWishes = self.totalWishes - 1
            UserDefaults.standard.set(self.totalWishes, forKey: "total")
            self.totalWishes = UserDefaults.standard.object(forKey: "total") as! Int
            self.countLabel.text = String(self.trueWishes) + "/" + String(self.totalWishes)
            
            self.myTableView.reloadData()
            UserDefaults.standard.synchronize()
        }

        deleteButton.backgroundColor = UIColor.black
        
        return [deleteButton]
        
    }

}


