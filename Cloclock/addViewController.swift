
import UIKit
import CoreData
class addViewController:UIViewController,setDelegate{
    @IBOutlet weak var tableview: UITableView!
    var time=["上午","下午"]
    var tablelabel=["重复","标签","铃声","叫醒方式"]
    var delegate:timeDelegate!
    var detaillabel=["永不","闹钟","超级玛丽","普通"]
    var repeat=[0,0,0,0,0,0,0]
    var repeatDetail=[" 周日"," 周一"," 周二"," 周三"," 周四"," 周五"," 周六"]
    @IBOutlet weak var picker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        var temporaryBarButtonItem=UIBarButtonItem()
        temporaryBarButtonItem.title = "返回"
        temporaryBarButtonItem.target = self
        temporaryBarButtonItem.action = Selector("返回")
        temporaryBarButtonItem.tintColor=UIColor.redColor()
        UINavigationBar.appearance().tintColor=UIColor.redColor()
        self.navigationItem.backBarButtonItem=temporaryBarButtonItem
        picker.datePickerMode=UIDatePickerMode.Time
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var navigationController = segue.destinationViewController as setViewController
        var index=tableview.indexPathForSelectedRow()
        var cell=sender as UITableViewCell
        navigationController.title=cell.textLabel!.text!
        if cell.textLabel?.text=="重复" {
            navigationController.contect=self.repeat
        }else{
            navigationController.contect=cell.detailTextLabel?.text!
        }
        navigationController.delegate=self
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }
    @IBAction func save(sender: AnyObject) {
        var context=(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        var row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context!)
        row.setValue(self.repeat, forKey: "repeat")
        row.setValue(self.detaillabel[1], forKey: "label")
        row.setValue(self.detaillabel[2], forKey: "music")
        row.setValue(self.picker.date, forKey: "date")
        row.setValue(false, forKey: "on")
        context?.save(nil)
        
        self.dismissViewControllerAnimated(true, completion: {() in
            let date = self.picker.date
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "HH:mm"
            let dat = "日期："+dateFormat.stringFromDate(date)
            self.delegate.timesure()
        })
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {() -> Void in
        })
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
       cell.detailTextLabel?.text=self.detaillabel[indexPath.row]
       cell.textLabel?.text=tablelabel[indexPath.row]
       return cell
    }
    func repeatSure(index:Int,judge:Bool) {
        if judge {
            self.repeat[index]=1
        }else{
            self.repeat[index]=0
        }
        var b=0
        var c=0
        self.detaillabel[0]=""
        for a in repeat{
            if a == 1 {
                c++
                self.detaillabel[0]+=self.repeatDetail[b]
            }
            b++
        }
        if self.detaillabel[0]=="" {
            self.detaillabel[0]="永不"
        }
        if c==7 {
            self.detaillabel[0]="每天"
        }
        tableview.reloadData()
    }
    func labelSure(label:String){
        self.detaillabel[1]=label
        tableview.reloadData()
    }
    func musicSure(music: String) {
        self.detaillabel[2]=music
        tableview.reloadData()
    }
}
