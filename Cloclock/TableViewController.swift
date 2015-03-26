
import UIKit
import CoreData
class TableViewController: UITableViewController,timeDelegate,tablereloddelegate{

    var time:String!
    var hour:Int!
    var min:Int!
    var context:NSManagedObjectContext!
    var contextdetial=[AnyObject]()
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var entity=NSFetchRequest(entityName: "Time")
        self.context=(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        self.contextdetial=context!.executeFetchRequest(entity, error: nil)!
        
       
        var title=UILabel(frame: CGRectMake(0, 0, 100, 100))
        title.textAlignment=NSTextAlignment.Center
        title.font=UIFont(name: "Zapfino", size: 20)
        title.center.x=self.view.center.x
        title.text="闹钟"
        title.textColor=UIColor.greenColor()
        self.navigationItem.titleView=title
        self.navigationController?.navigationBar.backgroundColor=UIColor.greenColor()
        //UIColor(red: 220/255, green: 255/255, blue: 220/255, alpha: 1)
        var appdetegate = UIApplication.sharedApplication().delegate as AppDelegate
        appdetegate.delegate=self
        
        
        tableview.separatorStyle=UITableViewCellSeparatorStyle.None
        tableview.backgroundColor=UIColor(red: 235/255, green: 251/255, blue: 215/255, alpha: 1)
        var a=UIImageView(frame: self.view.frame)
        a.image=UIImage(named: "green.png")
        
        tableview.backgroundView=a

    }
    func reload() {
        self.tableview.reloadData()
    }
    func timesure(){

        var entity=NSFetchRequest(entityName: "Time")
        self.context=(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        self.contextdetial=context!.executeFetchRequest(entity, error: nil)!

        
       self.tableview.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueStr = "\(segue.identifier!)"
        if segueStr == "add" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as addViewController
            controller.delegate = self
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return contextdetial.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let noon=cell.viewWithTag(1) as UILabel
        let label=cell.viewWithTag(2) as UILabel
        let time=cell.viewWithTag(3) as UILabel
        let swit=cell.viewWithTag(4) as UISwitch
        let date = contextdetial[indexPath.row].valueForKey("date") as? NSDate
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let dat = dateFormat.stringFromDate(date!)
        dateFormat.dateFormat = "HH"
        self.hour=dateFormat.stringFromDate(date!).toInt()
      
        let on=contextdetial[indexPath.row].valueForKey("on") as? Bool
        if on! {
            swit.on=on!
        }else{
            swit.on=on!
        }
        
        
        label.text=contextdetial[indexPath.row].valueForKey("label") as?  String
        if self.hour>=12{
            self.hour = self.hour-12
            time.text=dat
            noon.text="下午"
        }else{
            time.text=dat
            noon.text="上午"
        }
        

        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        println("删除\(indexPath.row)")
   
        let con=contextdetial[indexPath.row] as Cloclock
        if con.on as Bool {
            //修改数据
            con.on=false
            self.context.save(nil)
            //取消推送
            cancellocalnotification(indexPath.row)
        }

        
        self.context=(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        context.deleteObject(self.contextdetial[indexPath.row] as NSManagedObject)
        context.save(nil)
        var entity=NSFetchRequest(entityName: "Time")
        self.contextdetial=context.executeFetchRequest(entity, error: nil)!
        
        tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    @IBAction func SwitChange(sender: AnyObject) {
        
        let swit=sender as UISwitch
        let cell=swit.superview?.superview as UITableViewCell
        let row=tableview.indexPathForCell(cell)!.row
        var con=contextdetial[row] as Cloclock

        if swit.on {
             //修改数据
             con.on=true
             self.context.save(nil)
            
        var notification=UILocalNotification()
        notification.fireDate=con.valueForKey("date") as? NSDate
        notification.timeZone=NSTimeZone.defaultTimeZone()
        notification.soundName="1.wav"
        notification.alertBody="Time Over"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }else{
            
            //修改数据
            con.on=false
            self.context.save(nil)
            //取消推送
            cancellocalnotification(row)

        }
    }
    //取消推送
    func  cancellocalnotification(row:Int){
        var mark=0
        for i in 0...row {
            var con=contextdetial[i] as Cloclock
            if con.on as Bool {
                mark++
            }
        }
        
        let local=UIApplication.sharedApplication()
        let cancelnotification=local.scheduledLocalNotifications[mark] as UILocalNotification
        local.cancelLocalNotification(cancelnotification)
    
    }
  
}
