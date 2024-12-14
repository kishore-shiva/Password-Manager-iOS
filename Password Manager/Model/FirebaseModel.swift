//
//  FirebaseModel.swift
//  Password Manager
//
//  Created by Kishore Shiva Saravanan on 10/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class FirebaseModel {
    
    private static var db = Firestore.firestore()
    
    private static var userEmail: String = ""
    private static var userName: String = ""
    private static var userPhotoURL: String = ""
    private static var dataBoxes = [DataBox]()
    
    func fetchData(completion: @escaping ([DataBox]) -> Void) {
        
        FirebaseModel.dataBoxes = []
        
        FirebaseModel.db.collection(FirebaseModel.userEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                completion([])
            } else {
                for document in snapshot?.documents ?? [] {
                    let topic = document.data()["website or account name"] as? String ?? "Unknown"
                    let usernameOrCardNo = document.data()["username or card No"] as? String ?? "Unknown"
                    let mailId = document.data()["mail-id"] as? String
                    let passwordOrPin = document.data()["password or PIN"] as? String
                    let additionalDetails = document.data()["additional details"] as? String
                    
                    let dataBox = DataBox(
                        id: document.documentID,
                        topic: topic,
                        UsernameOrCardNo: usernameOrCardNo,
                        mailId: mailId ?? "",
                        passwordOrPin: passwordOrPin ?? "",
                        additionalDetails: additionalDetails ?? ""
                    )
                    
                    FirebaseModel.dataBoxes.append(dataBox)
                }
                completion(FirebaseModel.dataBoxes)
            }
        }
    }
    
    func updateData(dataBox: DataBox?, completion: @escaping (Bool) -> Void) {
        print("inside FirebaseModel UpdateData(), editedDataBox: \(String(describing: dataBox))")
        let documentID = dataBox?.id ?? ""
        let updatedData: [String: Any] = [
            "website or account name": dataBox?.topic ?? "",
            "username or card No": dataBox?.UsernameOrCardNo ?? "",
            "mail-id": dataBox?.mailId ?? "",
            "password or PIN": dataBox?.passwordOrPin ?? "",
            "additional details": dataBox?.additionalDetails ?? ""
        ]
        
        FirebaseModel.db.collection(FirebaseModel.userEmail).document(documentID).setData(updatedData) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                print("Document successfully updated!")
                completion(true)
            }
        }
    }
    
    func createData(dataBox: DataBox, completion: @escaping (Bool) -> Void) {
        print("Inside FirebaseModel createData(), newDataBox: \(dataBox)")
        
        // Prepare the data to be added
        let newData: [String: Any] = [
            "website or account name": dataBox.topic,
            "username or card No": dataBox.UsernameOrCardNo,
            "mail-id": dataBox.mailId,
            "password or PIN": dataBox.passwordOrPin,
            "additional details": dataBox.additionalDetails
        ]
        
        // Add a new document to the collection
        FirebaseModel.db.collection(FirebaseModel.userEmail).addDocument(data: newData) { error in
            if let error = error {
                print("Error creating document: \(error)")
                completion(false)
            } else {
                print("Document successfully created!")
                completion(true)
            }
        }
    }
    
    func deleteData(documentID: String, completion: @escaping (Bool) -> Void) {
        print("Inside FirebaseModel deleteData(), documentID: \(documentID)")
        
        // Reference the document by its ID and delete it
        FirebaseModel.db.collection(FirebaseModel.userEmail).document(documentID).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                completion(false)
            } else {
                print("Document successfully deleted!")
                completion(true)
            }
        }
    }
    
    func signInWithGoogle() async -> Bool{
        
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            fatalError("No client ID found in Firebase Configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else{
            print("There is no root view controller")
            return false
        }
        
        do{
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else{
                print("Google authentication error")
                return false
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User: \(firebaseUser.uid) and email: \(firebaseUser.email ?? "unknown")")
            
            FirebaseModel.userEmail = firebaseUser.email ?? ""
            FirebaseModel.userName = firebaseUser.displayName ?? ""
            FirebaseModel.userPhotoURL = firebaseUser.photoURL?.absoluteString ?? ""
            
            return true
        }
        catch{
            print(error.localizedDescription)
            return false;
        }
    }
    
    func getUserEmail() -> String {
        return FirebaseModel.userEmail
    }
    
    func getUserName() -> String {
        return FirebaseModel.userName
    }
    
    func getUserPhotoURL() -> String {
        return FirebaseModel.userPhotoURL
    }
    
    func getDataBoxes() -> [DataBox] {
        return FirebaseModel.dataBoxes
    }
}

