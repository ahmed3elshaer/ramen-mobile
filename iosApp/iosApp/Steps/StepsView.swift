import SwiftUI
import Shared
import CoreHaptics

struct RecipeStepView: View {
    let recipe: Recipe
    let steps: [Recipe.AnalyzedInstructionStep]

    @SwiftUI.State private var currentStepIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    @SwiftUI.State private var engine: CHHapticEngine?
    @SwiftUI.State private var showCompletionView = false
    @SwiftUI.State private var gradientPhase: CGFloat = 0.0

    init(recipe: Recipe) {
        self.recipe = recipe
        self.steps = recipe.analyzedInstructions[recipe.analyzedInstructions.startIndex].steps
    }

    var body: some View {
        ZStack {
            if showCompletionView {
                completionGradientBackground
                    .onAppear {
                        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: true)) {
                            gradientPhase = 1.0
                        }
                    }
            } else {
                // Dark black dominated gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.black.opacity(0.9),
                        Color.black.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top progress indicators
                    stepsProgressIndicators()
                        .padding([.top, .horizontal], 16)
                        .padding(.bottom, 8)

                    // Steps content in a TabView for horizontal swiping
                    TabView(selection: $currentStepIndex) {
                        ForEach(steps.indices, id: \.self) { index in
                            ZStack {
                                InstructionStepView(step: steps[index])
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .animation(.easeInOut, value: currentStepIndex)

                                // Transparent tappable layers for navigation
                                HStack {
                                    // Left tap area: move backward
                                    Color.clear
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            guard currentStepIndex > 0 else { return }
                                            provideHapticFeedback()
                                            withAnimation(.easeInOut) {
                                                currentStepIndex -= 1
                                            }
                                        }

                                    // Right tap area: move forward
                                    Color.clear
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if currentStepIndex < steps.count - 1 {
                                                provideHapticFeedback()
                                                withAnimation(.easeInOut) {
                                                    currentStepIndex += 1
                                                }
                                            } else {
                                                // User finished all steps, show completion view
                                                showCompletionView = true
                                                provideHapticFeedback(type: .success)
                                            }
                                        }
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentStepIndex)
                    .gesture(
                        DragGesture().onEnded { value in
                            // Swipe logic
                            if value.translation.width < -50 {
                                // Swipe left -> next step
                                if currentStepIndex < steps.count - 1 {
                                    provideHapticFeedback()
                                    withAnimation(.easeInOut) {
                                        currentStepIndex += 1
                                    }
                                } else {
                                    // Finished all steps
                                    showCompletionView = true
                                    provideHapticFeedback(type: .success)
                                }
                            } else if value.translation.width > 50 {
                                // Swipe right -> previous step
                                if currentStepIndex > 0 {
                                    provideHapticFeedback()
                                    withAnimation(.easeInOut) {
                                        currentStepIndex -= 1
                                    }
                                }
                            }
                        }
                    )
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .onAppear(perform: prepareHaptics)
    }

    // MARK: - Animated Completion Gradient
    private var completionGradientBackground: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color.purple,
            Color.red,
            Color.orange,
            Color.yellow,
            Color.green,
            Color.blue
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
        .blur(radius: 10)
        .hueRotation(.degrees(gradientPhase * 360))
        .overlay(
            VStack {
                Text("Congratulations!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("You’ve finished all the steps.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        )
    }

    // MARK: - Progress Indicators
    @ViewBuilder
    private func stepsProgressIndicators() -> some View {
        HStack(spacing: 4) {
            ForEach(steps.indices, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Base track
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.3))
                        // If index <= currentStepIndex, fill the entire bar
                        if index <= currentStepIndex {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: geometry.size.width)
                                .animation(.linear, value: currentStepIndex)
                        }
                    }
                }
                .frame(height: 4)
            }
        }
        .frame(height: 4)
    }

    // MARK: - Haptics
    private func prepareHaptics() {
        // Prepare haptic engine if available
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

struct InstructionStepView: View {
    let step: Recipe.AnalyzedInstructionStep

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 20) {
                
                // Instructions card
                cardView(title: "Instructions") {
                    Text(step.step)
                        .typography(.p1)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }

                // Ingredients card
                if !step.ingredients.isEmpty {
                    cardView(title: "Ingredients") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(step.ingredients, id: \.self.hashValue) { ingredient in
                                Text(ingredient.name.capitalized)
                                    .typography(.p2)
                            }
                        }
                    }
                }

                // Equipment card
                if !step.equipment.isEmpty {
                    cardView(title: "Equipment") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(step.equipment, id: \.self.hashValue) { equipment in
                                Text(equipment.name.capitalized)
                                    .typography(.p2)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 40)
            .padding(.bottom, 100) // Extra bottom padding for comfort
        }
    }

    @ViewBuilder
    private func cardView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .typography(.s1)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            content()
        }
        .padding(20)
        .background(
            // Card background with blue tint
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.15))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        )
    }
}
