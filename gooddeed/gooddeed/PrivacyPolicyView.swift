//
//  PrivacyPolicyView.swift

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.title)
                    .bold()

                Text("""
Effective Date: June 19, 2025

Thank you for using Good Deeds Reminder! Your privacy is important to us.

1. No Data Collection  
We do not collect, store, or share any personal information or user data. All reminders and data created within the app remain on your device and are not transmitted to any servers.

2. No Third-Party Services  
The app does not use any third-party analytics, tracking tools, advertising SDKs, or external APIs.

3. Local Storage  
All information is stored locally on your device. You have full control over your data and can delete it anytime by removing the app.

4. Children's Privacy  
This app does not collect data from children. Since we collect no data at all, it is safe for all ages.

5. Changes to This Policy  
If any changes are made to this policy in the future, they will be updated within the app and/or on this page.

6. Contact  
If you have any questions or concerns, feel free to contact us at:  
minamemisevic86@gmail.com
""")
                    .font(.body)
                    .padding(.top)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

//  Created by Mina Memisevic on 19. 6. 2025..
//

