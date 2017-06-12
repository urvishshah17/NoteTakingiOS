
import UIKit
import  CoreData

class TableViewController: UITableViewController,NSFetchedResultsControllerDelegate{
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>={
        var fetchRequest=NSFetchRequest<NSFetchRequestResult>()
        let itemEntity=NSEntityDescription.entity(forEntityName: "Item", in: self.context)
        fetchRequest.entity=itemEntity
        
        let sortDescriptors=NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors=[sortDescriptors]
        
        let fetchedResultsController=NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate=self
        return fetchedResultsController
        
    }()

    @IBOutlet var tblData: UITableView!
  
    
    var items : [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
            
        }
        catch {
            let error=error as NSError
            print(error.description)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        getdata()
        tableView.reloadData()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1  }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell

        let item = fetchedResultsController.object(at: indexPath) as! Item
        
        cell.textLabel?.text = item.name
        cell.imageView?.image = UIImage(data: item.image as! Data)
        //cell.detailTextLabel?.text = "\(item.userLat!)" + "_" + "\(item.userLong!)"
      
        return cell

    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete
        {
            let item = items[indexPath.row]
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                items = try context.fetch(Item.fetchRequest())
            }
            catch
            {
                print ("failed")
            }
            tableView.reloadData()
            
            
        }
    }
    

    func getdata()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            items = try context.fetch(Item.fetchRequest())
        }
        catch{
            print("failed")
        }
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        
        if self.tblData.isEditing {
            self.tblData.isEditing=false
            self.navigationItem.leftBarButtonItem?.title="Edit"
            self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditClicked(_:)))
        }
        else
        {
            self.tblData.isEditing=true
            self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnEditClicked(_:)))
            
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "Edit"
         {
         
            let path = tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: path!)
            let indexPath = tableView.indexPath(for: cell!)
             let itemController : ViewController = segue.destination as! ViewController
            let nItem : Item = fetchedResultsController.object(at: indexPath!) as! Item
            itemController.nItem = nItem
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath)
        {
            self.performSegue(withIdentifier: "Edit", sender: self)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
