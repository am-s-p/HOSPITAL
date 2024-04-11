import SwiftUI
import FirebaseFirestore

enum UserType: String, CaseIterable {
    case employee = "Employee"
    case patient = "Patient"
    case register = "Register"
}


struct ContentView: View {
    @State private var selectedUserType: UserType = .employee
    @State private var id: String = ""
    @State private var dob: String = ""
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var isLoggedInEmployee : Bool = false
    @State private var isLoggedInPatient : Bool = false
    @State private var Registered : Bool = false
    
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            if isLoggedInEmployee{
                EmployeePage(employeeID: id)
                    .navigationBarItems(trailing: Button("Sign Out") {
                        isLoggedInEmployee = false
                        id = ""
                    })
            }
            else if isLoggedInPatient{
                PatientPage(patientID: number)
                    .navigationBarItems(trailing: Button("Sign Out") {
                        isLoggedInPatient = false
                        id = ""
                    })
            }
            else if Registered{
                RegisteredPage(id: id)
                    .navigationBarItems(trailing: Button("Sign Out") {
                        Registered = false
                        id = ""
                    })
            }
            else {
                LoginPage(id: $id, dob: $dob, name: $name, number: $number, isLoggedInEmployee: $isLoggedInEmployee, isLoggedInPatient: $isLoggedInPatient, Registered: $Registered)
            }
        }
    }
}
struct LoginPage: View{
    
    
    let db = Firestore.firestore()
    
    
    @State private var selectedUserType: UserType = .employee
    @Binding var id: String
    @Binding var dob: String
    @Binding var name: String
    @Binding var number: String
    @Binding var isLoggedInEmployee : Bool
    @Binding var isLoggedInPatient : Bool
    @Binding var Registered : Bool
    var body: some View {
        NavigationView{
            VStack {
                Text("HOSPITAL")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Picker("Select User Type", selection: $selectedUserType) {
                    ForEach(UserType.allCases, id: \.self) { userType in
                        Text(userType.rawValue).tag(userType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedUserType == .employee  {
                    TextField("name", text: $name)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(name.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                    TextField("Employee ID", text: $id)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(id.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                    
                    TextField("Date of Birth", text: $dob)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(dob.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                }
                if selectedUserType == .patient {
                    TextField("name", text: $name)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(name.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                    TextField("Patient Phone Number", text: $number)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(id.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                        
                    
                    TextField("Date of Birth", text: $dob)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.01))
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(dob.isEmpty ? Color.mint : Color.clear, lineWidth: 1)
                                            )
                }
                if selectedUserType == .register {
                    TextField("name", text: $name)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Date of Birth", text: $dob)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("contact Number", text: $number)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Email ID", text: $id)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
                if selectedUserType == .patient {
                    Button(action: {
                        // Here you can perform login/authentication based on userType, id, and dob
                        // For demo purposes, let's just print the values
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                            isLoggedInPatient = true
                        }
                     
                        
                        print("User Type: \(self.selectedUserType.rawValue)")
                        print("ID: \(self.number)")
                        print("Date of Birth: \(self.dob)")
                    }) {
                        Text("Login")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                if selectedUserType == .employee{
                    Button(action: {
                        // Here you can perform login/authentication based on userType, id, and dob
                        // For demo purposes, let's just print the values
                        isLoggedInEmployee = true
                        
                        print("User Type: \(self.selectedUserType.rawValue)")
                        print("ID: \(self.id)")
                        print("Date of Birth: \(self.dob)")
                    }) {
                        Text("Login")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                if selectedUserType == .register{
                    Button(action: {
                        // Here you can perform login/authentication based on userType, id, and dob
                        // For demo purposes, let's just print the values
                        
                        //MARK: send data to the firebase
                        db.collection("patientDB")
                            .document(number)
                            .setData( [
                                "name" : name,
                                "dob" : dob,
                                "contactNumber" : number,
                                "emailID" : id
                            ]
                            )
                            
                        
                        
                        
                        
                        Registered = true
                        print("User Type: \(self.selectedUserType.rawValue)")
                        print("ID: \(self.id)")
                        print("Date of Birth: \(self.dob)")
                    }) {
                        Text("Register")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }.padding()
                }
                Spacer()
            }
            .padding()
        }
    }
}

enum Employeepage : String, CaseIterable {
    case Doctor = "Doctor"
    case Staff = "Staff"
    case nurse = "Nurse"
}




struct EmployeePage: View {
    let employeeID: String
    @State private var selectedTab : Employeepage = .Doctor
    
    let db = Firestore.firestore()
    
    @State var name: String = ""
    @State var age: String = ""
    @State var address: String = ""
    @State var contactNumber: String = ""
    @State var department: String = ""
    @State var position: String = ""
    
    @State var appointmentSchedule: String = ""
    
    var body: some View {
        VStack {
            Text("Welcome Employee!")
                .font(.title)
                .padding()
            Text("Employee ID: \(employeeID)")
                .padding()
            Picker("Select User Type", selection: $selectedTab) {
                ForEach(Employeepage.allCases, id: \.self) { userType in
                    Text(userType.rawValue).tag(userType)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            if selectedTab == .Doctor {
                var _ =                 db.collection("employeeDB").document(employeeID).getDocument { (document, error) in
                    if let document = document{
                        name = document.data()?["name"] as? String ?? "Nil"
                        age = document.data()?["age"] as? String ?? "Nil"
                        address = document.data()?["address"] as? String ?? "Nil"
                        contactNumber = document.data()?["contactNumber"] as? String ?? "Nil"
                        department = document.data()?["department"] as? String ?? "Nil"
                        appointmentSchedule = document.data()?["appointmentSchedule"] as? String ?? "Nil"
                    }
                }

                Text("Name = Dr. \(name)")
                Text("Age = \(age)")
                Text("Address : \(address)")
                Text("Contact Number : \(contactNumber)")
                Text("Department : \(department)")
                    .padding(.bottom)
                
                Text("Appointment Schedule").font(.title).bold()
                Text("Today : \(appointmentSchedule)")
                
                Text("")
            } else if selectedTab == .Staff{
                
                var _ = db.collection("staffDB").document(employeeID).getDocument { (document, error) in
                    if let document = document{
                        name = document.data()?["name"] as? String ?? "Nil"
                        age = document.data()?["age"] as? String ?? "Nil"
                        contactNumber = document.data()?["contactNumber"] as? String ?? "Nil"
                        department = document.data()?["department"] as? String ?? "Nil"
                        position = document.data()?["position"] as? String ?? "Nil"
                        
                    }
                }

                
                Text("Name = Dr. \(name)")
                Text("Age = \(age)")
                Text("Contact Number : \(contactNumber)")
                Text("Department : \(department)")
                Text("Position : \(position)")
            }
            Spacer()
        }

    }
}





enum Patientpage: String, CaseIterable {
    case profile = "Profile"
    case appointment = "Appointment"
    case payment = "Payments"
}
struct PatientPage : View {
    @State private var selectedTab : Patientpage = .profile
    
    let db = Firestore.firestore()
    
    let patientID : String
    
    init(patientID: String){
        self.patientID = patientID
    }
    
    @State private var department : String = ""
    @State private var Doctor : String = ""
    @State private var Date : String = ""
    @State private var time : String = ""
    @State private var symptoms : String = ""
    @State private var CardName : String = ""
    @State private var CardNumber : String = ""
    @State private var Expire : String = ""
    @State private var cvc : String = ""
    
    
    @State var patientName: String = ""
    @State var patientAge: String = ""
    @State var patientDOB: String = ""
    @State var patientPhoneNumber: String = ""
    @State var patientEmail: String = ""
    @State var patientAddress: String = ""
    @State var patientDisease: String = ""
    
    var body: some View{
        VStack {
            Text("Welcome Patient!")
                .font(.title)
                .padding()
            Text("Patient ID : \(patientID)")
                .padding()
            Picker("Select User Type", selection: $selectedTab) {
                ForEach(Patientpage.allCases, id: \.self) { userType in
                    Text(userType.rawValue).tag(userType)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            if selectedTab == .profile {
                Text("Name : \(patientName)")
                Text("Age : 22")
                Text("DOB : \(patientDOB)")
                Text("Contact Number : \(patientPhoneNumber)")
                Text("Email : \(patientEmail)")
                Text("Address : Sona Ganchi, Bengal")
                Text("Disease : HIV +ve / AIDS")
                
            }
            if selectedTab == .appointment {
                TextField("Department", text: $department)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Doctor", text: $Doctor)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Date", text: $Date)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Time", text: $time)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("symptoms", text: $symptoms)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            if selectedTab == .payment {
                TextField("Card Holder's Name", text: $CardName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Card Number", text: $CardNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Expire Date", text: $Expire)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("CVC", text: $cvc)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
        }
        .onAppear{
            
            db.collection("patientDB").document(patientID).getDocument { (document, error) in
                
                if let document = document{
                    patientName = document.data()?["name"] as? String ?? "Nil"
                    patientPhoneNumber = document.data()?["contactNumber"] as? String ?? "Nil"
                    patientDOB = document.data()?["dob"] as? String ?? "Nil"
                    patientEmail = document.data()?["emailID"] as? String ?? "Nil"
                }
            }
        }
    }
        
}
struct RegisteredPage : View {
    let id: String
    
    var body: some View{
        VStack {
            Text("Welcome Patient!")
                .font(.title)
                .padding()
            Text("ID : \(id)")
                .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
