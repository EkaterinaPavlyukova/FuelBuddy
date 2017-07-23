//
//  LoginViewController.swift
//  FuelBuddy
//
//  Created by Mac user on 21.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
import Firebase

enum Enter: String {
	case login = "Войти"
	case signUp = "Регистрация"
	
	mutating func changeValue(){
		switch self {
		case .login:
			self = .signUp
		case .signUp:
			self = .login

		}
	}
}

class LoginViewController: UIViewController {
	
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var nameTextFieldHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var loginSignUpbutton: UIBarButtonItem!
	@IBOutlet weak var registrationButton: UIButton!
	@IBOutlet weak var emailTextField: UnderLinedTextField!
	@IBOutlet weak var nameTextField: UnderLinedTextField!
	@IBOutlet weak var passwordTextField: UnderLinedTextField!
	@IBOutlet weak var inputContanerView: UIView!
	
	var ref: DatabaseReference!
	
	var enter: Enter? {
		didSet{
			
			let title: String = enter == .login ? Enter.signUp.rawValue : Enter.login.rawValue
			let	inputConstant: CGFloat = enter == .login ? 100 : 150
			let	nameConstant: CGFloat = enter == .login ? 0 : 50
			update(loginSignUpTitle: title, inputConstant: inputConstant, nameConstant: nameConstant)
			
		}
	}

	
	//MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureInputViewContaner()
		setupNavigationBar()
		
		enter = .signUp
		ref = Database.database().reference(fromURL: "https://fuelbuddy-e0ab6.firebaseio.com/")
		
	}
	
	func login(email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
			guard let strongSelf = self else { return }
			strongSelf.registrationButton.isEnabled = true
			strongSelf.loginSignUpbutton.isEnabled = true
			if user == nil {
				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				strongSelf.showAlert(title:  "Аккаунт не найден.", message: "Зарегестрируйтесь, пожалуйста", actions: [action])
			}else {
				strongSelf.goToMap()
			}
		}
		
	}
	
	func goToMap() {
		let sb = UIStoryboard.init(name: "Main", bundle: nil)
		let mvc = sb.instantiateViewController(withIdentifier: String(describing: MapViewController.self)) as! MapViewController
		
		navigationController?.pushViewController(mvc, animated: true)

	}
	
	func signUp(name:String, email: String, password: String)  {
		Auth.auth().createUser(withEmail: email, password: password) { [weak self](user, error) in
			
			guard let strongSelf = self else { return }
			strongSelf.registrationButton.isEnabled = true
			strongSelf.loginSignUpbutton.isEnabled = true

			guard let uid = user?.uid, error == nil else {
				
				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				strongSelf.showAlert(title:  "Ошибка", message: "Проверьте данные", actions: [action])
				return
				
			}
			let imageName = NSUUID().uuidString
			let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
			
			if	let uploadData = UIImagePNGRepresentation((strongSelf.avatarImageView.image)!){
				
				storageRef.putData(uploadData, metadata: nil, completion: { [weak self](metadata, error) in
					
					guard let strongSelf = self, error == nil else { return }
					
					if let photoURL = metadata?.downloadURL()?.absoluteString{
						let values: [String: Any] = ["name": name, "email": email, "photoURL": photoURL]
						strongSelf.registerUserIntoDatabase(with: uid, values: values)

					}
					
				})
			}
	
		}
		
	}
	
	private func registerUserIntoDatabase(with uid:String, values:[String:Any]){
		let userReference = ref.child("users").child(uid)
		
		userReference.updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
			guard let strongSelf = self else { return }
			guard error == nil else { return }
			strongSelf.goToMap()
		})

	}
	
	@IBAction func avatarTapped(_ sender: UITapGestureRecognizer) {
		let controller = UIAlertController(title: "Add your photo", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
		controller.addAction(
			UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) -> Void in
				self.openImagePicker(.camera)
			}))
		
		controller.addAction(UIAlertAction(title: "Choose photo", style: UIAlertActionStyle.default, handler: { (action) -> Void in
			self.openImagePicker(.photoLibrary)
		}))
		controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
			self.presentedViewController?.dismiss(animated: false, completion: nil)
		}))
		present(controller, animated: true, completion: nil)
		

	}
	
	@IBAction func registerButtonTapped(_ sender: UIButton) {
		view.endEditing(true)
		registrationButton.isEnabled = false
		loginSignUpbutton.isEnabled = false
		guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
			
			let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
				self.registrationButton.isEnabled = true
				self.loginSignUpbutton.isEnabled = true

			})
			
			showAlert(title: "Необходимо заполнить све поля", message: "Проверьте и повторите попытку", actions: [action])
			
			return
		}
		
		switch enter! {
		case .login:
			login(email: email, password: password)
		case .signUp:
			signUp(name: name, email: email, password: password)
			
		}
		
	}
	
	@IBAction func loginTapped(_ sender: UIBarButtonItem) {
		enter?.changeValue()
		
	}
	
	//MARK: - Private Methods
	private func update(loginSignUpTitle: String, inputConstant: CGFloat, nameConstant: CGFloat ){
		registrationButton.alpha = 0
		loginSignUpbutton.title = loginSignUpTitle
		UIView.animate(withDuration: 0.5, animations: {
			self.registrationButton.setTitle(self.enter?.rawValue, for: .normal)
			self.registrationButton.alpha = 1
			self.inputViewHeightConstraint.constant = inputConstant
			self.nameTextFieldHeightConstraint.constant = nameConstant
		})
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationItem.title = ""
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.barTintColor = UIColor.clear
		self.navigationController?.navigationBar.backgroundColor = UIColor.clear
		self.navigationController?.navigationBar.tintColor = UIColor.white
		
	}
	
	private func configureInputViewContaner() {
		inputContanerView.layer.cornerRadius = 10
		inputContanerView.layer.masksToBounds = true
		
	}
	
	private func cleanFields(){
		nameTextField.text = ""
		emailTextField.text = ""
		passwordTextField.text = ""
	}
	
	private func showAlert(title:String, message:String, actions: [UIAlertAction]) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach{alert.addAction($0)}
		present(alert, animated: true, completion: nil)
	}

	
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func openImagePicker(_ sourceType:UIImagePickerControllerSourceType){
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		picker.sourceType = sourceType
		if sourceType == .camera{
			picker.cameraDevice = .front
		}
		
		present(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if info[UIImagePickerControllerMediaType] as? String == "public.image" {
			if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
				self.avatarImageView.contentMode = .scaleAspectFill
				self.avatarImageView.image = image
				self.avatarImageView.circleWithImage()
			}
		} else {
			debugPrint("error - loading phoho failed")
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}


