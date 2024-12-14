import SwiftUI
import Shared

struct RecipeStepView: View {
    let recipe: Recipe
    let steps: [Recipe.AnalyzedInstructionStep]
    @SwiftUI.State private var currentStepIndex: Int = 0

    init(recipe: Recipe) {
        self.recipe = recipe
        self.steps = recipe.analyzedInstructions[recipe.analyzedInstructions.startIndex].steps
    }

    var body: some View {
        ZStack {
            VStack {
                // Progress Indicator
                stepsProgressBar()

                // Current Step Content in Full Screen
                instructionStepView()

                Spacer()
            }
            .padding()
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 && currentStepIndex < steps.count - 1 {
                            currentStepIndex += 1
                        } else if value.translation.width > 0 && currentStepIndex > 0 {
                            currentStepIndex -= 1
                        }
                    }
            )
        }
    }

    // 1. Dynamic Gradient Background
    var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple, .pink]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .opacity(0.8)
        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true))
    }

    // 2. Noise Layer
    var noiseLayer: some View {
        Color.black
            .opacity(0.05)
            .blendMode(.overlay)
            .ignoresSafeArea()
    }

    // 3. Material Effect Layer
    var materialLayer: some View {
        Color.clear
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
    }

    // 4. Progress Bar
    @ViewBuilder
    private func stepsProgressBar() -> some View {
        ProgressView(value: Double(currentStepIndex) / Double(steps.count - 1))
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.vertical, 10)
    }

    // 5. Instruction Step View with Full-Screen Content
    @ViewBuilder
    private func instructionStepView() -> some View {
        InstructionStepView(step: steps[currentStepIndex])
            .transition(.slide)
            .animation(.easeInOut)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Updated InstructionStepView with Full-Screen Content and Text Instead of Images
struct InstructionStepView: View {
    let step: Recipe.AnalyzedInstructionStep

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(step.step)
                .font(.title)
                .bold()
                .padding(.bottom)

            if !step.ingredients.isEmpty {
                ingredientsListView()
            }

            if !step.equipment.isEmpty {
                equipmentsListView()
            }

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private func ingredientsListView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
                .bold()

            ForEach(step.ingredients, id: \.self.hashValue) { ingredient in
                Text("\(ingredient.name)")
                    .font(.body)
            }
        }
    }

    @ViewBuilder
    private func equipmentsListView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Equipments")
                .font(.headline)
                .bold()

            ForEach(step.equipment, id: \.self.hashValue) { equipment in
                Text("\(equipment.name)")
                    .font(.body)
            }
        }
    }
}

