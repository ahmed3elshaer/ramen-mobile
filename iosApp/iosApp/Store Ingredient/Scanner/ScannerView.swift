import SwiftUI
import AVFoundation
import Vision
import Shared

class ScannerViewModel: ObservableObject {
    @Published var detectedIngredients: [DetectedIngredient] = []
    @Published var isScanning = false
    @Published var cameraError: Error?
    
    private var captureSession: AVCaptureSession?
    private let visionQueue = DispatchQueue(label: "com.ramen.vision")
    
    struct DetectedIngredient: Identifiable {
        let id = UUID()
        let name: String
        let confidence: Float
        let boundingBox: CGRect
        var isConfirmed = false
        var animationOffset: CGFloat = 1000
    }
    
    func startScanning() {
        setupCamera()
        startObjectDetection()
    }
    
    private func setupCamera() {
        // Camera setup implementation
    }
    
    private func startObjectDetection() {
//        guard let model = try? VNCoreMLModel(for: YourCustomModel().model) else { return }
        
        // Object detection implementation
    }
}

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    @Environment(\.dismiss) private var dismiss
    let onScanComplete: ([AutocompleteIngredient]) -> Void
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreview()
                .edgesIgnoringSafeArea(.all)
            
            // Scanning overlay
            ScanningOverlay(isScanning: $viewModel.isScanning)
            
            // Detected items overlay
            DetectedItemsOverlay(
                detectedIngredients: viewModel.detectedIngredients
            )
            
            // Bottom controls
            VStack {
                Spacer()
                
                BottomControlPanel(
                    confirmedCount: viewModel.detectedIngredients.filter(\.isConfirmed).count,
                    onComplete: {
                        // Convert detected ingredients to AutocompleteIngredient
                        let ingredients = viewModel.detectedIngredients
                            .filter(\.isConfirmed)
//                            .map { /* conversion logic */ }
//                        onScanComplete(ingredients)
                        dismiss()
                    }
                )
            }
        }
        .onAppear {
            viewModel.startScanning()
        }
    }
}

struct ScanningOverlay: View {
    @Binding var isScanning: Bool
    
    var body: some View {
        ZStack {
            // Scanning frame
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.activePrimary, lineWidth: 2)
                .frame(width: 280, height: 280)
                .overlay(
                    // Scanning animation
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .activePrimary.opacity(0.5), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 2)
                        .offset(y: isScanning ? 140 : -140)
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: isScanning
                        )
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
                        .blur(radius: 2)
                )
        }
    }
}

struct DetectedItemsOverlay: View {
    let detectedIngredients: [ScannerViewModel.DetectedIngredient]
    
    var body: some View {
        ZStack {
            ForEach(detectedIngredients) { ingredient in
                DetectedItemBadge(ingredient: ingredient)
            }
        }
    }
}

struct DetectedItemBadge: View {
    let ingredient: ScannerViewModel.DetectedIngredient
    @SwiftUI.State private var isAnimating = false
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .typography(.s2)
                .foregroundColor(.white)
            
            Text("\(Int(ingredient.confidence * 100))%")
                .typography(.s2)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.activePrimary)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .position(
            x: ingredient.boundingBox.midX,
            y: ingredient.boundingBox.minY - 20
        )
        .offset(x: isAnimating ? 0 : ingredient.animationOffset)
        .onAppear {
            withAnimation(.spring(
                response: 0.6,
                dampingFraction: 0.7,
                blendDuration: 0
            )) {
                isAnimating = true
            }
        }
    }
}

struct BottomControlPanel: View {
    let confirmedCount: Int
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(confirmedCount) items detected")
                .typography(.h3)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Add to Fridge")
                    }
                    .typography(.p1)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.activePrimary)
                    .cornerRadius(25)
                }
            }
        }
        .padding(.bottom, 40)
        .background(
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// Camera preview using UIViewRepresentable
struct CameraPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        // Setup preview layer
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
} 
