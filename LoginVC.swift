//
//  LoginVC.swift
//  Suprema_Salsa
//
//  Created by Miguel Mexicano Herrera on 27/05/15.
//  Copyright (c) 2015 ilab. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,NSURLConnectionDataDelegate {
    
    var receivedData: NSMutableData!
  
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
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
    
    
    
    @IBAction func Login(sender: AnyObject) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Campos Vacios!"
            alertView.message = "Porfavor Ingresa un Nombre de Usuario y Contraseña"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
        else
        {
            let url = NSURL(string: "http://supremasalsa.azurewebsites.net/movil/movil.php");
            
            
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            
            var bodyData="username=\(username)&password=\(password)"
            
           println("Enviado a php \(bodyData)")
            
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            let conn = NSURLConnection(request: request, delegate: self)
            
            conn?.start()
          
                    
        }
        
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
        

        var err: NSError?
        var myJSON = NSJSONSerialization.JSONObjectWithData(receivedData, options: .MutableLeaves, error:&err) as? NSDictionary
        
        
        if let parseJSON = myJSON {
            // Now we can access value of First Name by its key
            var respuesta = parseJSON["aceptado"] as? String
            
            if(respuesta=="true")
            {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Mensaje"
                alertView.message = "Bienvenido"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            else
            {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Mensaje Error"
                alertView.message = "No Eres Usuario"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
          
        }
        
        
    }
    
    
}

