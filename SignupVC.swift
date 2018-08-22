//
//  SignupVC.swift
//  Suprema_Salsa
//
//  Created by Miguel Mexicano Herrera on 07/06/15.
//  Copyright (c) 2015 ilab. All rights reserved.
//

import UIKit

class SignupVC: UIViewController,NSURLConnectionDataDelegate{
    
    var receivedData: NSMutableData!
    
    @IBOutlet weak var NombreRtxt: UITextField!
    @IBOutlet weak var Fechatxt: UITextField!
    @IBOutlet weak var Telefonotxt: UITextField!
    @IBOutlet weak var Correotxt: UITextField!
    @IBOutlet weak var Aliastxt: UITextField!
    @IBOutlet weak var Contraseñatxt: UITextField!
    
    @IBOutlet weak var RepitContratxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        receivedData = NSMutableData(capacity: 0)
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func HideKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }

    
    @IBAction func SignUp(sender: AnyObject) {
        var nombre:NSString = NombreRtxt.text
        var fecha:NSString = Fechatxt.text
        var correo:NSString = Correotxt.text
        var telefono:NSString = Telefonotxt.text
        var username:NSString = Aliastxt.text
        var password:NSString = Contraseñatxt.text
        var repitpassword:NSString = RepitContratxt.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") || repitpassword.isEqualToString(""))
        {
            self.MensajeAlerta("los campos con (*) son Obligatorios")
            
        }
            
        else
        {

            if(password.isEqualToString(repitpassword as String))
            {
                let url = NSURL(string: "http://supremasalsa.azurewebsites.net/movil/registro.php");
                
                
                let request = NSMutableURLRequest(URL: url!)
                
                request.HTTPMethod = "POST"
                
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                
                var bodyData="nombre=\(nombre)&username=\(username)&password=\(password)&fecha=\(fecha)&correo=\(correo)&telefono=\(telefono)"
                
                println("Enviado a php \(bodyData)")
                
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                
                let conn = NSURLConnection(request: request, delegate: self)
                
                conn?.start()
                
            }
            else
            {
             self.MensajeAlerta("Las Contraseñas deben ser Iguales")
            
            }
        
        }
        
    }
    
    @IBAction func Regresar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func MensajeAlerta(mensaje:String)
    {
    
        
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Mensaje!"
        alertView.message = mensaje
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        receivedData.length=0
        
    }
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receivedData.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("Error: \(error.localizedDescription): \(error.userInfo)")
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        var data = NSString(data: receivedData, encoding: NSASCIIStringEncoding) as! String
        
        println(data)
        
        var err: NSError?
        var myJSON = NSJSONSerialization.JSONObjectWithData(receivedData, options: .MutableLeaves, error:&err) as? NSDictionary
        
        
        if let parseJSON = myJSON {
            // Now we can access value of First Name by its key
            var respuesta = parseJSON["aceptado"] as? String
            
         
            if(respuesta=="true")
            {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Mensaje"
                alertView.message = "Registrado"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            else
            {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Mensaje Error"
                alertView.message = "El formato de la fecha es Año-Mes-dia"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        }
        
        
    }

    
}


