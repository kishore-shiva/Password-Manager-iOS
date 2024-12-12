import SwiftUI

struct DataBoxView: View {
    @State private var isExpanded: Bool = false
    @State private var isFormVisible: Bool = false
    @State private var editClicked = false
    @State var dataBox: DataBox
    
    var contentView: ContentView
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 10) {
                // First line with topic and icons
                HStack {
                    Text(dataBox.topic)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading, 8)

                    Spacer()

                    HStack(spacing: 10) {
                        Button(action: {
                            // Show the pop-up when the edit button is clicked
                            print("show pop up change")
                            
                            editClicked = true
                            ContentView.editDataBox = dataBox
                            contentView.updateShowPopup(value: true)
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                                .font(.title2)
                        }

                        Button(action: {
                            // Trash button action
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                    .padding(.trailing, 8)
                }

                // Second line with label and value
                HStack {
                    Text("Username/Card.No")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Text(dataBox.UsernameOrCardNo)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

                // Toggle expansion on tap
                Button(action: {
                    isExpanded.toggle()
                }) {
                    HStack {
                        Text(isExpanded ? "Hide Details" : "Show Details")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 5)
                }

                // Expanded details section with improved design
                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        keyValueView(key: "Mail ID:", value: dataBox.mailId)
                        keyValueView(key: "Password/PIN:", value: dataBox.passwordOrPin)
                        keyValueView(key: "Additional Details:", value: dataBox.additionalDetails)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(5)
                    .padding(.top, 5)
                }
            }
            .padding()
            .background(Color.black)
            .border(Color.orange, width: 2)
            .cornerRadius(10)
            .padding(.horizontal, 3)
        }
    }

    // Helper function to create key-value views
    private func keyValueView(key: String, value: String) -> some View {
        HStack {
            Text(key)
                .font(.subheadline)
                .foregroundColor(.orange)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(nil) // Ensures multi-line display for long values
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

