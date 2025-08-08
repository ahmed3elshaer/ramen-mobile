import SwiftUI
import Shared
import CoreHaptics

struct RecipeStepView: View {
    let recipe: Recipe
    let steps: [Recipe.AnalyzedInstructionStep]
    
    @SwiftUI.State private var currentStepIndex: Int = 0
    @SwiftUI.State private var stepTimer: Int = 0
    @SwiftUI.State private var isTimerRunning: Bool = false
    @SwiftUI.State private var completedSteps: Set<Int> = []
    @SwiftUI.State private var showCompletionView = false
    @SwiftUI.State private var dragOffset: CGFloat = 0
    @SwiftUI.State private var engine: CHHapticEngine?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    // Timer publisher
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.steps = recipe.analyzedInstructions.first?.steps ?? []
    }
    
    var currentStep: Recipe.AnalyzedInstructionStep {
        steps[currentStepIndex]
    }
    
    // Break down complex expressions to avoid compiler issues
    private var darkGradientColors: [Color] {
        [
            Color.black.opacity(0.8),
            Color.darkMint.opacity(0.4),
            Color.forestGreen.opacity(0.3),
            Color.black.opacity(0.9)
        ]
    }
    
    private var lightGradientColors: [Color] {
        [
            Color.black.opacity(0.6),
            Color.darkMint.opacity(0.3),
            Color.forestGreen.opacity(0.2),
            Color.black.opacity(0.8)
        ]
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colorScheme == .dark ? darkGradientColors : lightGradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Break down complex transition animations
    private var insertionTransition: AnyTransition {
        .move(edge: dragOffset < 0 ? .trailing : .leading).combined(with: .opacity)
    }
    
    private var removalTransition: AnyTransition {
        .move(edge: dragOffset < 0 ? .leading : .trailing).combined(with: .opacity)
    }
    
    private var stepTransition: AnyTransition {
        .asymmetric(insertion: insertionTransition, removal: removalTransition)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient matching RecipeDetail
                backgroundGradient
                .ignoresSafeArea()
                
                if showCompletionView {
                    CompletionView(recipe: recipe)
                } else {
                    VStack(spacing: 0) {
                        // Header with title, step info and timer
                        HeaderView(
                            recipe: recipe,
                            currentStep: currentStepIndex + 1,
                            totalSteps: steps.count,
                            timer: stepTimer,
                            isTimerRunning: isTimerRunning
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        // Progress bar
                        ProgressBarView(currentStep: currentStepIndex, totalSteps: steps.count)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        
                        // Main content area
                        ZStack {
                            ForEach(steps.indices, id: \.self) { index in
                                if index == currentStepIndex {
                                    StepContentView(
                                        step: steps[index],
                                        stepNumber: index + 1,
                                        isCompleted: completedSteps.contains(index)
                                    )
                                    .offset(x: dragOffset)
                                    .opacity(abs(dragOffset) > 50 ? 0.7 : 1.0)
                                    .scaleEffect(abs(dragOffset) > 50 ? 0.95 : 1.0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: dragOffset)
                                    .transition(stepTransition)
                                }
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        if value.translation.width > 100 && currentStepIndex > 0 {
                                            // Swipe right - previous step
                                            currentStepIndex -= 1
                                            provideHapticFeedback()
                                        } else if value.translation.width < -100 && currentStepIndex < steps.count - 1 {
                                            // Swipe left - next step
                                            currentStepIndex += 1
                                            provideHapticFeedback()
                                        }
                                        dragOffset = 0
                                    }
                                }
                        )
                        
                        // Bottom buttons and navigation hints
                        VStack(spacing: 12) {
                            // Action buttons
                            HStack(spacing: 12) {
                                Button {
                                    withAnimation(.spring()) {
                                        if completedSteps.contains(currentStepIndex) {
                                            completedSteps.remove(currentStepIndex)
                                        } else {
                                            completedSteps.insert(currentStepIndex)
                                        }
                                        provideHapticFeedback()
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: completedSteps.contains(currentStepIndex) ? "checkmark.circle.fill" : "circle")
                                        Text("Mark Complete")
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                }
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Button {
                                    nextStep()
                                } label: {
                                    Text(currentStepIndex == steps.count - 1 ? "Finish" : "Next Step")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                }
                                .background(Color.teal)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Navigation hints
                            NavigationHintsView()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onReceive(timer) { _ in
            if isTimerRunning {
                stepTimer += 1
            }
        }
        .onAppear {
            prepareHaptics()
            startTimer()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    private func nextStep() {
        if currentStepIndex < steps.count - 1 {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentStepIndex += 1
                resetTimer()
                provideHapticFeedback()
            }
        } else {
            showCompletionView = true
            provideHapticFeedback(type: .success)
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
    }
    
    private func resetTimer() {
        stepTimer = 0
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine failed to start: \(error.localizedDescription)")
        }
    }
    
    private func provideHapticFeedback(type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

// MARK: - Header View
private struct HeaderView: View {
    let recipe: Recipe
    let currentStep: Int
    let totalSteps: Int
    let timer: Int
    let isTimerRunning: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                }
                .glassEffect(.regular, in: Circle())
                .clipShape(Circle())
                
                Spacer()
                
                Button {
                    // Play/pause timer action
                } label: {
                    Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                }
                .glassEffect(.regular, in: Circle())
                .clipShape(Circle())
            }
            
            VStack(spacing: 4) {
                Text(recipe.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack {
                Text(formatTime(timer))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("~15m each")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Progress Bar View
private struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .fill(index <= currentStep ? Color.teal : Color.white.opacity(0.3))
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

// MARK: - Step Content View
private struct StepContentView: View {
    let step: Recipe.AnalyzedInstructionStep
    let stepNumber: Int
    let isCompleted: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large step number with glass effect
                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .glassEffect(.regular, in: Circle())
                    
                    Text("\(stepNumber)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .scaleEffect(isCompleted ? 1.1 : 1.0)
                .animation(.spring(), value: isCompleted)
                
                // Step title
                Text("Step \(stepNumber)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Instruction content
                VStack(alignment: .leading, spacing: 16) {
                    Text(step.step)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                    
                    // Key Ingredients section
                    if !step.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.teal)
                                Text("Key Ingredients")
                                    .font(.headline)
                                    .foregroundColor(.teal)
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(step.ingredients.prefix(4), id: \.id) { ingredient in
                                    Text(ingredient.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.teal.opacity(0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
}

// MARK: - Navigation Hints View
private struct NavigationHintsView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.caption)
                    Text("Tap here")
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.6))
                
                Text("•")
                    .foregroundColor(.white.opacity(0.4))
                
                HStack(spacing: 4) {
                    Text("Tap here")
                        .font(.caption)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.6))
            }
            
            Text("Tap left or right edges to navigate • Swipe to change steps")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Completion View
private struct CompletionView: View {
    let recipe: Recipe
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 60))
            
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("You've completed making \(recipe.title)!")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 32)
    }
}
