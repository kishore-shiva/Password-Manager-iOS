import SwiftUI

struct EditOrCreateForm: View {
    @Binding var editClicked: Bool
    var dataBox: DataBox?
    
    @State private var topicText: String
    @State private var showTopicError: Bool
    
    var contentView: ContentView
    
    init(editClicked: Binding<Bool>, dataBox: DataBox?, contentView: ContentView) {
        self._editClicked = editClicked
        self.dataBox = dataBox
        self._topicText = State(initialValue: dataBox?.topic ?? "")
        self._showTopicError = State(initialValue: false)
        self.contentView = contentView
    }
    
    var body: some View {
        VStack {
            Text("Edit Details")
                .font(.title3)
                .padding()
                .foregroundColor(.white)
            
            LabeledTextField(label: "Topic", text: $topicText, showError: $showTopicError)
            
            Button(action: {
                if validateForm() {
                    print("validate form is true")
                    // Firebase operation to update
                    
                    editClicked = false
                    contentView.updateShowPopup(value: false)// Close the pop-up
                } else {
                    print("validate form is false")
                }
            }) {
                Text("Close")
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
        print("topic: \(topicText) value: \(showTopicError)")
        return !topicText.isEmpty
    }
}

struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    @Binding var showError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(showError ? "\(label) - Required" : label)
                .font(.footnote)
                .foregroundColor(showError ? .red : .gray)
            
            TextField("", text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.gray, lineWidth: 1)
            )
        }
        .padding()
    }
}
