//
//  ContentView.swift
//  BeterRest
//
//  Created by Santhosh Srinivas on 16/01/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmt = 8.0
    @State private var coffeeAmt = 1
    @State private var wakeUp = defaultWakeTime//Date.now
//    @State private var alertTitle = ""
    @State private var alertMsg = ""
//    @State private var showAlert = false
//    var cups = ["1 Cup", "2 Cups", "3 Cups", "4 Cups", "5 Cups", "6 Cups", "7 Cups", "8 Cups", "9 Cups", "10 Cups", "11 Cups", "12 Cups", "13 Cups", "14 Cups", "15 Cups", "16 Cups", "17 Cups", "18 Cups", "19 Cups", "20 Cups"]
//    @State private var iniCups = 3
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View{
        NavigationView{
            Form{
//                Spacer()
//                Section("When do you wish to Wake up??") {
//                    DatePicker("Plese select a time" , selection: $wakeUp, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                }
                VStack(alignment: .leading, spacing: 0){
                    Text("When do you wish to Wake up??")
//                        .padding()
    //                    .foregroundColor(.white)
    //                Spacer()
                    DatePicker("Plese select a time" , selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
    //                    .multilineTextAlignment(.center)
    //                    .fontWeight(bold())
    //                Spacer()
                }
                .padding()
//
                VStack(alignment: .leading, spacing: 0){
                    Text("How much sleep do you need?")
//                        .padding()
    //                    .foregroundColor(.white)
    //                Spacer()
                    Stepper("\(sleepAmt.formatted()) hours", value: $sleepAmt, in: 4...12, step: 0.25)
//                        .padding()
                }
                .padding()
                
//                Spacer()
                Picker("How much cups of coffe a day", selection: $coffeeAmt ) {
                    ForEach(1..<21){//cups, id: \.self){
                        Text("\($0) Cup(s)")
                    }
                }
                .padding()
//                VStack(alignment: .leading, spacing: 0){
//
//                    Text("How much coffee do you drink in a day?")
////                        .padding()
//    //                    .foregroundColor(.white)
//
//                    Stepper(coffeeAmt == 1 ? "1 cup" : "\(coffeeAmt) cups", value: $coffeeAmt, in: 1...25)
////                        .padding()
//                }
//                .padding()
                
//                Spacer()
//                VStack(alignment: .trailing){
                    Button{
                        calculate()
                    } label: {
                        Text("Done")
                            .padding()
                    }
                Text(alertMsg)
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
                
            }
            .font(.headline)
//            .background(Color.blue)
            .navigationTitle("BetterRest")
            
//            .toolbar {
//                Button{
//                    calculate()
//                } label: {
//                    Text("Calculate")
////                        .fontWeight(.bold)
//                        .font(.headline.bold())
//                        .foregroundColor(.black)
//                }
//            }
//            .alert(alertTitle, isPresented: $showAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMsg)
//            }
            
            
        }
        
        
    }
    func calculate(){
        do{
            
            let config = MLModelConfiguration()
            let model = try sleepCalculator(configuration: config)
            // as our time is in seconds in the CoreML
            let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (component.hour ?? 0) * 60 * 60
            let minute = (component.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmt, coffee: Double(coffeeAmt))
            
            let sleepTime = wakeUp - prediction.actualSleep
//            alertTitle = "You're IDEAL sleep time is..."
            alertMsg = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch{
//            alertTitle = "Error"
            alertMsg = "Sorry, There was an error calculating your time"
        }
//        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
