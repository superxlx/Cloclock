

import UIKit
class setViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var text: UITextField!
    let date:[String!]=["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    let music:[String!]=["打击乐","发动机","钟声","跑跑卡丁车","超级玛丽"]
    var tablelabel:[String!] = []
    var delegate:setDelegate!
    var image:UIImage!
    var state:String!
    var selectmusic=[0,0,0,0,1]
    var selectmusicnumber=4
    var contect:AnyObject!
    var repeat=[Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        set()        
    }
    func set(){
        var a=self.title
        switch a!{
            case "重复":tablelabel=date
                        state="重复"
                        self.repeat=self.contect as [Int]
                        tableview.hidden=false
            case "标签":text.hidden=false
                        state="标签"
                        self.text.text=self.contect as String
                        text.becomeFirstResponder()
            case "铃声":tablelabel=music
                        state="铃声"
                        setmusic()
                        tableview.hidden=false
        default:break
        }
    }
    @IBAction func Done(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setmusic(){
        for var i=0;i<self.music.count;i++ {
            if music[i]==self.contect as String {
                self.selectmusic[i]=1
                self.selectmusicnumber=i
            }else{
                self.selectmusic[i]=0
            }
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablelabel.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text=tablelabel[indexPath.row]
        if state=="重复" {
            if repeat[indexPath.row]==1{
                cell.accessoryType=UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType=UITableViewCellAccessoryType.None
            }
        }
        if state=="铃声" {
        if self.selectmusic[indexPath.row] == 1 {
            cell.accessoryType=UITableViewCellAccessoryType.Checkmark
        }else{
           cell.accessoryType=UITableViewCellAccessoryType.None
        }
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if state=="重复"{
        let cell=tableview.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.None {
            cell?.accessoryType=UITableViewCellAccessoryType.Checkmark
            delegate.repeatSure(indexPath.row,judge: true)
        }else{
            cell?.accessoryType=UITableViewCellAccessoryType.None
            delegate.repeatSure(indexPath.row,judge: false)
        }
        }else if state=="铃声" {
            let cell=tableview.cellForRowAtIndexPath(indexPath)
            if cell?.accessoryType == UITableViewCellAccessoryType.None {
                cell?.accessoryType=UITableViewCellAccessoryType.Checkmark
                delegate.repeatSure(indexPath.row,judge: true)
            }
            self.selectmusic[indexPath.row]=1
            self.selectmusic[self.selectmusicnumber]=0
            self.selectmusicnumber=indexPath.row
            tableView.reloadData()
            delegate.musicSure(self.music[indexPath.row])
        }
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func textFieldDidEndEditing(textField: UITextField){
        delegate.labelSure(text.text)
    }
}
