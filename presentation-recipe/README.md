# Presentation Recipe Module - Functional Programming Approach

This module contains the presentation layer for recipe functionality in the Ramen app, refactored to use functional programming principles with Arrow.

## Design Decisions

### Why Functional Programming in the Presentation Layer?

1. **Predictable UI State**: Functional programming ensures UI state transitions are predictable and reproducible.
2. **Error Handling**: Using Arrow's `Either` monad makes errors first-class citizens in the codebase, improving error handling.
3. **Testability**: Pure functions are easier to test because they have no side effects.
4. **Composability**: Small, composable functions can be reused across different parts of the presentation layer.
5. **State Management**: Treating state as immutable data reduces bugs related to shared mutable state.

### Core Functional Concepts Used

#### Either and Option for Error Handling

Instead of throwing exceptions, we use Arrow's `Either<A, B>` to represent operations that can fail and `Option<A>` to represent the absence of a value.

```kotlin
suspend fun getRecipe(id: String): Either<UiError, Recipe>
```

#### Function Composition with flatMap and map

We chain operations using functional combinators like `flatMap` and `map`:

```kotlin
getRecipe(id)
  .map { recipe -> recipe.toUiModel() }
  .flatMap { uiModel -> updateState(uiModel) }
```

#### Effect Handling with IO

Using Arrow's IO type to encapsulate side effects:

```kotlin
fun getRecipeInfo(id: String): IO<UiError, RecipeInfo>
```

#### State as Data

Treating UI state as immutable data:

```kotlin
data class RecipeState(
  val isLoading: Boolean,
  val recipes: List<Recipe>,
  val error: UiError?
)
```

## Migration Strategy

We've followed a phased approach to adoption:

1. Convert simple state classes to immutable data models
2. Refactor store actions to handle effects functionally
3. Implement error handling with Either
4. Extract pure functions for core logic
5. Add functional composition for complex operations

This allows us to gradually introduce functional programming concepts while maintaining compatibility with the existing codebase.
