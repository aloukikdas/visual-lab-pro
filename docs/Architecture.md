# Software Architecture Document

## Design Philosophy
Visual Lab Pro follows a strict Separation of Concerns (SoC) principle. The UI layer (Native Scilab GUI) is completely decoupled from the mathematical simulation engine.

## Directory Map
* `/src/core`: Contains the Window Manager, routing system, and state management.
* `/src/modules`: Contains isolated logic for each laboratory environment. 
* `/src/shared`: Reusable UI components (buttons, text styling, frames) to maintain consistent typography and spacing.
* `/src/utils`: Mathematical helper functions, string manipulators, and the Theme Engine.

## State Management
Application state (current screen, active variables) will be stored in an encapsulated global Scilab structure (`global appState;`), strictly controlled via getter and setter functions to prevent unauthorized mutations.