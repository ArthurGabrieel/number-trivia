# Number Trivia App

Welcome to the Number Trivia app! This app provides interesting trivia and facts about numbers. Whether you're a math enthusiast or just curious, you'll find engaging information about various numbers.

## Features

- **Get Trivia by Number**: Retrieve trivia facts for a specific number.
- **Random Trivia**: Explore random trivia for a bit of fun.
- **User-friendly Interface**: Simple and intuitive design for a seamless user experience.

## Architecture and Development Approach

This app is developed using Clean Architecture principles and follows a Test-Driven Development (TDD) approach. Here's an overview:

### Clean Architecture

The app is structured based on Clean Architecture, which promotes separation of concerns and maintainability. It consists of the following layers:

- **Presentation**: Contains UI elements, including widgets, screens, and presenters.
- **Domain**: Represents the business logic and use cases.
- **Data**: Handles data access and external dependencies.

### Test-Driven Development (TDD)

Test-Driven Development is a fundamental part of the development process. We follow these steps:

1. **Write a Test**: Create a test that defines a function or improvements of a function.
2. **Run the Test**: Confirm that the test fails. If it doesn't, the new feature might already be implemented.
3. **Write the Code**: Write the minimum amount of code necessary to pass the test.
4. **Run the Test Again**: Confirm that the test passes.
5. **Refactor Code**: Refactor the code while keeping it functional.

## Getting Started

Follow these steps to get started with the Number Trivia app:

1. **Clone the Repository**:

    ```
    git clone https://github.com/ArthurGabrieel/number-trivia
    ```

2. **Install Dependencies**
    ```
    flutter pub get 
    ```
3. **Run the App**
   
   Ensure that you have Flutter installed and an emulator or simulator running.
    ```
    flutter run
    ```
