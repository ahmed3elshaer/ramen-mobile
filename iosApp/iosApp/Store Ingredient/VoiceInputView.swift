
import SwiftUI
import Speech

class VoiceRecognitionManager: ObservableObject {
    @Published var isRecording = false
    @Published var recognizedText = ""
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    func startRecording() {
        // Implementation for voice recognition
    }
    
    func stopRecording() {
        // Stop recording implementation
    }
}

struct VoiceInputButton: View {
    @StateObject private var voiceManager = VoiceRecognitionManager()
    let onRecognized: (String) -> Void
    
    var body: some View {
        Button(action: {
            if voiceManager.isRecording {
                voiceManager.stopRecording()
            } else {
                voiceManager.startRecording()
            }
        }) {
            Image(systemName: voiceManager.isRecording ? "waveform" : "mic.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Color.activePrimary)
                .clipShape(Circle())
                .scaleEffect(voiceManager.isRecording ? 1.1 : 1.0)
                .animation(.spring(), value: voiceManager.isRecording)
        }
    }
} 