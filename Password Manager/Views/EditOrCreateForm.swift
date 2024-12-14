import SwiftUI

struct EditOrCreateForm: View {
    var dataBox: DataBox?
    
    @State private var topicText: String
    @State private var showTopicError: Bool
    
    @State private var usernameText: String
    @State private var showUsernameError: Bool
    
    @State private var emailText: String
    
    @State private var passwordText: String
    @State private var showPasswordError: Bool
    
    @State private var additionalDetailsText: String
    
    var contentView: ContentView
    
    init(dataBox: DataBox?, contentView: ContentView) {
        self.dataBox = dataBox
        
        self._topicText = State(initialValue: dataBox?.topic ?? "")
        self._showTopicError = State(initialValue: false)
        self._usernameText = State(initialValue: dataBox?.UsernameOrCardNo ?? "")
        self._showUsernameError = State(initialValue: false)
        self._passwordText = State(initialValue: dataBox?.passwordOrPin ?? "")
        self._showPasswordError = State(initialValue: false)
        self._emailText =  State(initialValue: dataBox?.mailId ?? "")
        self._additionalDetailsText =  State(initialValue: dataBox?.additionalDetails ?? "")
        
        self.contentView = contentView
    }
    
    var body: some View {
        VStack {
            Text(contentView.getEditClicked() ? "Edit Details" : "Add new Crendentials")
                .font(.title3)
                .padding()
                .foregroundColor(.white)
            
            LabeledTextFieldWithError(label: "Topic", text: $topicText, showError: $showTopicError)
            
            LabeledTextFieldWithError(label: "Username/Card No", text: $usernameText, showError: $showUsernameError)
            
            LabeledTextFieldWithError(label: "Password", text: $passwordText, showError: $showPasswordError)
            
            LabeledTextField(label: "Associated Email", text: $emailText)
            
            LabeledTextArea(label: "Additional Details", text: $additionalDetailsText)
            
            Button(action: {
                if validateForm() {
                    print("validate form is true")
                    
                    if(contentView.getEditClicked()){
                        var editedDataBox: DataBox = DataBox(id: dataBox?.id ?? "", topic: topicText, UsernameOrCardNo: usernameText, mailId: emailText, passwordOrPin: passwordText, additionalDetails: additionalDetailsText)
                        
                        print("databox edit value: \(editedDataBox)")
                        
                        FirebaseModel().updateData(dataBox: editedDataBox) {success in
                            if success {
                                print("Update succeeded!")
                            } else {
                                print("Update failed.")
                            }
                        }
                        contentView.updateEditClicked(value: false)
                    }
                    else{
                        var newDataBox: DataBox = DataBox(id: "", topic: topicText, UsernameOrCardNo: usernameText, mailId: emailText, passwordOrPin: passwordText, additionalDetails: additionalDetailsText)
                        FirebaseModel().createData(dataBox: newDataBox) { success in
                            if success {
                                print("Data successfully added!")
                            } else {
                                print("Failed to add data.")
                            }
                        }
                    }
                    
                    contentView.updateDataBoxes()
                    contentView.updateShowPopup(value: false)// Close the pop-up
                } else {
                    print("validate form is false")
                }
            }) {
                Text(contentView.getEditClicked() ? "Edit" : "Create")
                    .font(.title2)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .frame(maxWidth: 300)
    }
    
    private func validateForm() -> Bool {
        showTopicError = topicText.isEmpty
        showPasswordError = passwordText.isEmpty
        showUsernameError = usernameText.isEmpty
        
        return (!topicText.isEmpty && !usernameText.isEmpty && !passwordText.isEmpty)
    }
}

struct LabeledTextFieldWithError: View {
    let label: String
    @Binding var text: String
    @Binding var showError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(showError ? "\(label) - Required" : label)
                .font(.footnote)
                .foregroundColor(showError ? .red : .orange)
            
            TextField("", text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.gray, lineWidth: 1)
            )
        }
    }
}

struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.footnote)
                .foregroundColor(.orange)
            
            TextField("", text: $text)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

struct LabeledTextArea: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.footnote)
                .foregroundColor(.orange)
            
            TextEditor(text: $text)
                .frame(height: 125) // Approximately 5 lines
                .padding(5)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

