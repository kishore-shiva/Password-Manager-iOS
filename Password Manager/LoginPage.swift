import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct LoginPage: View {
    @State private var isLoggedIn = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        if isLoggedIn {
            ContentView()
        } else {
            VStack {
                HStack {
                    Image(systemName: "lock.shield")
                        .font(.largeTitle)
                        .imageScale(.large)
                        .foregroundColor(.orange)
                    Text("Password Manager")
                        .font(.title)
                        .foregroundStyle(.black)
                }

                Button(action: {
                    Task {
                        let success = await FirebaseModel().signInWithGoogle()
                        if success {
                            isLoggedIn = true
                        } else {
                            showError = true
                            errorMessage = "Google Sign-In failed. Please try again."
                        }
                    }
                }) {
                    HStack{
                        Image("GoogleLogo").resizable().aspectRatio(contentMode: .fit).frame(width: 40.0, height: 40.0)
                        Text("Sign-in with Google")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 20)
                    .background(Color.black)
                    .cornerRadius(20)
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(.white)
            .padding()
        }
    }
}

#Preview {
    LoginPage()
}
