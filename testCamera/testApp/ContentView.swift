//  ContentView.swift
//  testApp
//
//  Created by Emanuele Pacilio on 23/03/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
            CameraView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width:25, height:25)
                    .position(x: 195, y:250)
                
            
//            VStack(spacing:10){
//                Text("Colore: ")
//                    .foregroundColor(.white)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .tracking(2)
//                Text("HEX :")
//                    .foregroundColor(.white)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .tracking(2)
//                Text("RGB : ")
//                    .foregroundColor(.white)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .tracking(2)
//            }
//            .background(Color.black)
//                .frame(width: 195, height: 200)
//                .position(x: 195, y:700)
            
            VStack {
                        Divider()
                        Spacer()
                        // Bleeds into TabView
                ZStack {
                    Rectangle()
                        .frame(height: 200)
                        .background(.black)
                    
                    HStack{
                        
                        VStack (alignment: .leading, spacing: 35) {
                            
                            Text("Color :")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            
                            Text("RGB :")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            
                            Text("Hex :")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            
                           
                        }.padding()
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 35){
                            Text("ROSSO")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            Text("23 234 434")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            Text("#ff0000")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                        }.padding()
                        
                    }
                    
                }
            }
                    
                
//            ZStack{
//                Rectangle()
//                    .fill(.black)
//                    .frame(maxWidth: .infinity, maxHeight: 200)
//                    .position(x: 195, y:700)
//
//                        VStack{
//                            Text("HEX :")
//                                .foregroundColor(.white)
//                                .position(x: 80, y:650)
//                                .fontWeight(.bold)
//                            Text("Colore :")
//                                .foregroundColor(.white)
//                                .position(x: 80, y:600)
//                                .fontWeight(.bold)
//
//                        }
//
//            }
                
            
        }.onAppear(perform: {camera.Check()})
    }
}


class CameraModel: ObservableObject{
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            
            let device = AVCaptureDevice.default(for: .video)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
