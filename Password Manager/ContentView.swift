//
//  ContentView.swift
//  Password Manager
//
//  Created by Kishore Shiva Saravanan on 08/12/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    
    @State private var isLoggedIn = true
    @State private var dataBoxes = [DataBox]()
    @State private var showEditForm = false
    @State private var showPopup = false // State to show the pop-up
    @State private var editClicked = false // State to show the pop-up
    
    static var editDataBox: DataBox? = nil
    
    var body: some View {
        if isLoggedIn {
            ZStack{
                VStack(spacing: 0){
                    
                    // Top bar with lock icon, title, and search button
                    HStack {
                        Spacer()
                        HStack {
                            Image(systemName: "lock.shield")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Password Manager")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        Button(action: {
                            // Add search button action here
                        }) {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.orange)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 40) // Slightly smaller height
                    .background(Color.black)
                    
                    //Top Bar with photo, name and sign-out button
                    HStack {
                        // User photo
                        if let url = URL(string: FirebaseModel().getUserPhotoURL()) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        // User name
                        Text(FirebaseModel().getUserName())
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        // Sign Out button
                        Button(action: {
                            // Add sign-out functionality here
                            signOut()
                            isLoggedIn = false
                        }) {
                            Text("Sign Out")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                    .background(Color.black)
                    
                    // Full-width "Add new credentials" button
                    Button(action: {
                        // Add action for "Add new credentials" button here
                    }) {
                        Text("Add new credentials")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                    // Optional for spacing between the buttons
                    
                    // Black box with rounded corners and orange border
                    ScrollView {
                                VStack {
                                    ForEach(dataBoxes) { dataBox in
                                        DataBoxView(dataBox: dataBox, contentView: self)
                                    }
                                }
                                .onAppear {
                                    FirebaseModel().fetchData { fetchedData in
                                                        dataBoxes = fetchedData
                                                    }
                                }
                            }
                    
                    Spacer()
                }
                
                // Overlay for the pop-up with transparency effect
                if showPopup {
                    Color.black.opacity(0.8) // Semi-transparent overlay
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPopup = false // Close pop-up when tapping outside
                        }
                    EditOrCreateForm(editClicked: $editClicked, dataBox: ContentView.editDataBox, contentView: self)
                }
            }
        }
        else{
            LoginPage()
        }
    }
    
    func updateShowPopup(value: Bool) {
            showPopup = value
        }
    
    func signOut() {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Error: SignOut() ---> \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
