//
//  ContentView.swift
//  Colorful
//
//  Created by Antonio Onorato on 05/04/23.
//

import SwiftUI
import AVFoundation
  
var red: CGFloat = 0.0
var green: CGFloat = 0.0
var blue: CGFloat = 0.0
 
 
var hexValue : String = ""
 
 
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
 
struct ColorMapping {
    let name: String
    let redRange: ClosedRange<Int>
    let greenRange: ClosedRange<Int>
    let blueRange: ClosedRange<Int>
    
}

func euclideanDistance(_ c1: ColorMapping, _ c2: ColorMapping) -> CGFloat {
    let dr = Double(c1.redRange.lowerBound - c2.redRange.lowerBound)
    let dg = Double(c1.greenRange.lowerBound - c2.greenRange.lowerBound)
    let db = Double(c1.blueRange.lowerBound - c2.blueRange.lowerBound)
    return CGFloat(sqrt(dr * dr + dg * dg + db * db))
}

func closestColor(_ colorMap: [ColorMapping], _ red: Int, _ green: Int, _ blue: Int) -> ColorMapping? {
    var closest: ColorMapping?
    var closestDistance = CGFloat.greatestFiniteMagnitude
    let targetColor = ColorMapping(name: "", redRange: red...red, greenRange: green...green, blueRange: blue...blue)
        
    
    for color in colorMap {
        let distance = euclideanDistance(color, targetColor)
        if distance < closestDistance {
            closest = color
            closestDistance = distance
        }
    }
    return closest
}


struct CameraView: View {
    @State private var backgroundColor: Color = .clear
    @StateObject var camera = CameraModel()
 
    let colorMap: [ColorMapping] = [
        ColorMapping(name: "Black", redRange: 0...56, greenRange: 0...56, blueRange: 0...56),
        ColorMapping(name: "White", redRange: 201...255, greenRange: 201...255, blueRange: 220...255),
        ColorMapping(name: "Dark Red", redRange: 150...199, greenRange: 0...30, blueRange: 0...30),
        ColorMapping(name: "Red", redRange: 200...255, greenRange: 0...50, blueRange: 0...50),
        ColorMapping(name: "Light Red", redRange: 255...255, greenRange: 100...149, blueRange: 100...149),
        ColorMapping(name: "Dark Green", redRange: 0...30, greenRange: 150...199, blueRange: 0...30),
        ColorMapping(name: "Green", redRange: 0...50, greenRange: 200...255, blueRange: 0...50),
        ColorMapping(name: "Light Green", redRange: 100...149, greenRange: 255...255, blueRange: 100...149),
        ColorMapping(name: "Dark Blue", redRange: 0...30, greenRange: 0...30, blueRange: 150...199),
        ColorMapping(name: "Blue", redRange: 0...50, greenRange: 0...50, blueRange: 200...255),
        ColorMapping(name: "Light Blue", redRange: 100...149, greenRange: 100...149, blueRange: 255...255),
        ColorMapping(name: "Dark Yellow", redRange: 200...255, greenRange: 150...199, blueRange: 0...30),
        ColorMapping(name: "Yellow", redRange: 255...255, greenRange: 200...255, blueRange: 0...50),
        ColorMapping(name: "Light Yellow", redRange: 255...255, greenRange: 255...255, blueRange: 100...149),
        ColorMapping(name: "Dark Orange", redRange: 200...255, greenRange: 100...139, blueRange: 0...30),
        ColorMapping(name: "Orange", redRange: 255...255, greenRange: 140...190, blueRange: 0...50),
        ColorMapping(name: "Light Orange", redRange: 255...255, greenRange: 191...219, blueRange: 100...149),
        ColorMapping(name: "Dark Brown", redRange: 60...99, greenRange: 30...69, blueRange: 0...30),
        ColorMapping(name: "Brown", redRange: 100...150, greenRange: 50...100, blueRange: 0...50),
        ColorMapping(name: "Light Brown", redRange: 150...199, greenRange: 100...149, blueRange: 0...50),
        ColorMapping(name: "Green", redRange: 128...154, greenRange: 128...154, blueRange: 0...64),
        ColorMapping(name: "Green", redRange: 75...90, greenRange: 83...97, blueRange: 40...50),
        ColorMapping(name: "Green", redRange: 0...34, greenRange: 35...70, blueRange: 0...34),
        ColorMapping(name: "Green", redRange: 0...64, greenRange: 128...255, blueRange: 0...64),
        ColorMapping(name: "Green", redRange: 0...50, greenRange: 153...204, blueRange: 0...50),
        ColorMapping(name: "Purple", redRange: 100...150, greenRange: 0...50, blueRange: 100...150),
        ColorMapping(name: "Pink", redRange: 255...255, greenRange: 150...200, blueRange: 150...200), ]

    
    var body: some View {
        
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
 
            VStack{
 
                if camera.isTaken{
 
                    HStack{
                        Spacer()
                        Button(action: camera.reTake, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }).padding(.trailing, 10)
                    }
 
 
                    HStack{
                        Spacer()
                        VStack (alignment: .leading, spacing: 35) {
                            Spacer()
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
//                        Color.black
                        VStack (alignment: .leading, spacing: 35) {
                            Spacer()
                            if abs(red - green) <= 15 && abs(red - blue) <= 15 && abs(green - blue) <= 15 && green > 50 && red > 50 && blue > 50 {
                                
                                HStack {
                                    Text("Grigio")
                                        .fontWeight(.black)
                                        .font(.system(size: 25))
                                        .foregroundColor(.white)
                                        .tracking(2)
                                    let synthesizer = AVSpeechSynthesizer()
                                    Button("🔈"){
                                        let utterance = AVSpeechUtterance(string: "Grigio")
                                        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
                                        utterance.pitchMultiplier = 2.0
                                        utterance.rate = 0.3
                                        synthesizer.speak(utterance)
                                    }
                                }
                                
                            } else if let closest = closestColor(colorMap, Int(red), Int(green), Int(blue)) {
                                HStack {
                                    Text("\(closest.name)")
                                        .fontWeight(.black)
                                        .font(.system(size: 25))
                                        .foregroundColor(.white)
                                        .tracking(2)
                                    let synthesizer = AVSpeechSynthesizer()
                                    Button("🔈"){
                                        let utterance = AVSpeechUtterance(string: closest.name)
                                        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
                                        utterance.pitchMultiplier = 2.0
                                        utterance.rate = 0.3
                                        synthesizer.speak(utterance)
                                    }
                                }
                                
                            } else {
                                Text("Null")
                                    .fontWeight(.black)
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                    .tracking(2)
                            }

                            Text("\(Int(red)) \(Int(green)) \(Int(blue))")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                            Text("\(hexValue)")
                                .fontWeight(.black)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .tracking(2)
                        }.padding()
                        Spacer()
                    }
                    .background(Color.black)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
 
                Spacer()
 
                HStack{
 
                    if !camera.isTaken{
 
                        VStack{
                            Rectangle()
                                .stroke(lineWidth: 3)
                                .frame(width:25, height:25)
                                .padding(.top, 250)
 
                            Spacer()
 
                            Button(action: camera.takePic, label: {
                                ZStack{
 
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65)
 
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 75, height: 75)
                                }
                            })
                        }
                    }
                }
            }
 
        }.onAppear(
            perform: {camera.Check()}
 
 
        )
    }
}

 
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
 
    @Published var isTaken = false
 
    @Published var session = AVCaptureSession()
 
    @Published var alert = false
 
    @Published var output = AVCapturePhotoOutput()
 
    @Published var preview : AVCaptureVideoPreviewLayer!
 
    @Published var picData = Data(count: 0)
 
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
 
    func takePic(){
            DispatchQueue.global(qos: .background).async {
                self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
 
                DispatchQueue.main.async {
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                        (timer) in self.session.stopRunning()
                    }
                    DispatchQueue.main.async {
                        withAnimation{self.isTaken.toggle()}
                    }
                }
            }
        }
 
 
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
 
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
        }
    }
 
 
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil{
            return
        }
 
        print("pic taken...")
 
        guard let imageData = photo.fileDataRepresentation() else {return}
 
        self.picData = imageData
 
        let image = UIImage(data: self.picData)!.averageColor
        red = image!.0
        green = image!.1
        blue = image!.2
        hexValue = String(format:"%02X", Int(red)) + String(format:"%02X", Int(green)) + String(format:"%02X", Int(blue))
    }
 
//    func getColor(){
//    }
//    //    private func setAverageColor() {
//    //            let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
//    //            let rgb = UIColor(Color(uiColor))
//    //            print(rgb)
//    //            backgroundColor = Color(uiColor)
//    //        }
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
 
 
extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: (CGFloat, CGFloat, CGFloat)? {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return nil }
 
        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: 700,
                                    y: 500,
                                    z: 25,
                                    w: 25)
 
        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
 
        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
 
        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
//        Convert our bitmap images of r, g, b, a to a UIColor
 
        return ( CGFloat(bitmap[0]), CGFloat(bitmap[1]), CGFloat(bitmap[2]) )
 
//        return UIColor(red: CGFloat(bitmap[0]) / 255,
//                       green: CGFloat(bitmap[1]) / 255,
//                       blue: CGFloat(bitmap[2]) / 255,
//                       alpha: CGFloat(bitmap[3]) / 255)
    }
 
 
}
