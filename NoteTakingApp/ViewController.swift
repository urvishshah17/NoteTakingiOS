

import UIKit
import CoreData
import MapKit
import CoreLocation

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate,CLLocationManagerDelegate {
   
    @IBOutlet weak var imgMap: MKMapView!
    
     @IBOutlet weak var txtName: UITextField!

    @IBOutlet weak var btnLocation: UIButton!
   
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    @IBOutlet weak var btnLibrary: UIBarButtonItem!
    
    var region : MKCoordinateRegion? = nil
    var myLocation : CLLocationCoordinate2D? = nil
    let manager = CLLocationManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var nItem : Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nItem != nil
        {
            txtName.text = nItem?.name
            imgview.image = UIImage(data: (nItem?.image)! as Data)
            
            let Lat : Double = Double((nItem?.userLat)!)!
            let Long : Double = Double((nItem?.userLong)!)!
            
            let locRecord = CLLocationCoordinate2D(latitude: Lat, longitude: Long)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = locRecord
            
            self.imgMap.removeAnnotations(imgMap.annotations)
            self.imgMap.addAnnotation(annotation)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func dismissmain()
    {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnCameraClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnLibraryClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
      
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        region = MKCoordinateRegionMake(myLocation!, span)
        imgMap.setRegion(region!, animated: true)
        self.imgMap.showsUserLocation = true
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgview.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel(_ sender: Any) {
        dismissmain()
    }
    @IBAction func btnSave(_ sender: Any) {
        
        if nItem != nil
            {
                editItem()
            }
            else
            {
                newItem()
            }
        dismissmain()
       
       // if !(self.txtName.text?.isEmpty)!
            
        
    }
    
    func newItem()
    {
        let context = self.context
        let ent = NSEntityDescription.entity(forEntityName: "Item", in: context)
        
        let nItem = Item(entity: ent!, insertInto: context)
        
        nItem.name = txtName.text
        nItem.image = (UIImagePNGRepresentation(imgview.image!)! as NSData?)
        
        let u_Lat = myLocation?.latitude
        let u_long = myLocation?.longitude
        nItem.userLat = "\(u_Lat!)"
        nItem.userLong = "\(u_long!)"
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
    func editItem()
    {
        self.nItem?.name = txtName.text
        self.nItem?.image = UIImagePNGRepresentation(imgview.image!)! as NSData?
        let u_Lat = myLocation?.latitude
        let u_long = myLocation?.longitude
        self.nItem?.userLat = "\(u_Lat!)"
        self.nItem?.userLong = "\(u_long!)"

        
        let Lat : Double = Double((self.nItem?.userLat)!)!
        let Long : Double = Double((self.nItem?.userLong)!)!
        
        let locRecord = CLLocationCoordinate2D(latitude: Lat, longitude: Long)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locRecord
        
        self.imgMap.removeAnnotations(imgMap.annotations)
        self.imgMap.addAnnotation(annotation)
        
    }
    

   
}

