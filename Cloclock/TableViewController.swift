//
//  TableViewController.swift
//  FunnyC
//
//  Created by xlx on 15/2/6.
//  Copyright (c) 2015年 xlx. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController,timeDelegate {

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
        
        tableview.backgroundColor=UIColor.yellowColor()
        
        navigationController?.navigationBar.backgroundColor=UIColor.blueColor()

    }
    func timesure(){
//        var addtime=Time()
        var entity=NSFetchRequest(entityName: "Time")
        self.context=(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        self.contextdetial=context!.executeFetchRequest(entity, error: nil)!

        
       self.tableview.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        swit.on=on! as Bool
        
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
   
        
//       //取消推送
//        let local=UIApplication.sharedApplication()
//        let cancelnotification=local.scheduledLocalNotifications[indexPath.row] as UILocalNotification
//        local.cancelLocalNotification(cancelnotification)
//    
//        
        
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
//        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
//        4     NSEntityDescription * entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
//        5     [fetchRequest setEntity:entity];
//        6
//        7     NSError * requestError = nil;
//        8     NSArray * persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
//        9
//        10     if ([persons count] > 0) {
//            11
//            12         Person * lastPerson = [persons lastObject];
//            13         // 更新数据
//            14         lastPerson.firstName = @"Hour";
//            15         lastPerson.lastName = @"Zero";
//            16         lastPerson.age = @21;
//            17
//            18         NSError * savingError = nil;
//            19         if ([self.managedObjectContext save:&savingError]) {
//                20             NSLog(@"successfully saved the context");
//                21
//                22         }else {
//                23             NSLog(@"failed to save the context error = %@", savingError);
//                24         }
//            25 
//            26 
//            27     }else {
//            28         NSLog(@"could not find any person entity in the context");
//            29     }
        
        
//        NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//        for (News *info in result) {
//            info.islook = islook;
//        }
//        
//        //保存
//        if ([context save:&error]) {
//            //更新成功
//            NSLog(@"更新成功");
//        }
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
            let local=UIApplication.sharedApplication()
            let cancelnotification=local.scheduledLocalNotifications[row] as UILocalNotification
            local.cancelLocalNotification(cancelnotification)

        }
    }
  
}
