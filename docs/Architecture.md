# System Architecture: Visual Lab Pro ⚙️

## 1. High-Level Design (The SPA Paradigm)
Visual Lab Pro is engineered to mimic a modern Single Page Application (SPA) entirely within Scilab 6. Instead of launching multiple separate `.sce` windows, the application relies on a central custom routing engine (`src/core/router.sci`). 

When a user navigates between labs:
1. The router intercepts the command.
2. It executes a memory-cleanup phase, safely querying and deleting all active `uicontrol` (Java Swing) and `axes` (OpenGL) child handles attached to the main window.
3. It conditionally invokes the required module's render function (e.g., `render_circuit()`), maintaining a single, continuous user session.

## 2. State Management & Memory (`VLP_CONTEXT`)
To avoid namespace collision and variable shadowing across multiple isolated module files, the application uses a strict central state manager.
* **Global Struct:** A singular global variable, `VLP_CONTEXT`, acts as the source of truth for the application state.
* **Handle Retention:** Pointers to active UI elements (sliders, labels) and dynamic graphics (polylines, markers) are stored in module-specific sub-structs (e.g., `VLP_CONTEXT.circuit.electrons`).
* **In-Memory Data Mutation:** Instead of re-rendering full plots (which is computationally expensive), callbacks dynamically mutate the `.data` property of retained handles, achieving real-time interaction without graphical lag.

## 3. The Dual-Rendering Pipeline (Java Swing vs. OpenGL)
Scilab 6 relies on two distinct internal rendering engines concurrently:
* **Java Swing:** Responsible for rendering UI elements (`uicontrol` panels, text, buttons, sliders).
* **OpenGL:** Responsible for mathematically plotting data, axes, polylines, and geometries.

**Architectural Decision (The Staircase Load):** 
During development, we explored `immediate_drawing = "off"` (Double Buffering) to eliminate UI load flickering. However, because we built a highly customized, layered Dark Theme, freezing the buffer disrupted the Java Swing transparency bridge, exposing raw white canvas backgrounds. 
* *Conclusion:* We optimized for visual fidelity over instant-draw. The application deliberately loads sequentially to force the engine to respect the dark canvas hierarchy, ensuring UI elements layer correctly over the background.

## 4. Animation & Threading Architecture (The Finite-Pulse Engine)
Scilab's event queue is strictly **single-threaded**. This presented a critical engineering challenge for the Circuit and Physics labs: an infinite `while` loop used for animation completely starves the UI event queue, permanently freezing `uicontrol` buttons (like a "STOP" button).

**The Solution:**
We abandoned infinite interrupts in favor of a **Finite Pulse Simulation Engine**. 
Animations (like electron flow) are encapsulated in mathematically bounded `for` loops (e.g., 150 frames) paired with a `sleep(30)` command to yield micro-control back to the OS. 
* *Result:* The animation runs at a smooth ~30FPS, allows asynchronous slider interactions (which update via Java threads) to mutate variables like speed and brightness mid-animation, and guarantees a safe, automatic shutdown without deadlocking the main Scilab process.

## 5. Procedural Geometry & Mathematical Modeling
Instead of relying on static imported images, the Circuit Lab constructs its schematic procedurally using native OpenGL geometries. This allows for dynamic integration with the simulation math.

* **Sine Wave Component Mapping:** The zig-zag resistor is not randomly drawn. It is mathematically generated, and the traveling electron markers map to it dynamically using a bounded sine wave formulation: 
  $y = 4.0 + 0.3 \times \sin(\frac{2\pi}{0.4} \times (x - 4.2))$
* **RGB Power Scaling:** Visual feedback is driven by physics. The system calculates real-time power dissipation ($P = V \times I$) and mathematically maps this to an RGB color matrix, dynamically changing the literal glow of the bulb marker from dark gray to bright yellow based on the slider inputs.
* **Handle Safety Checks:** Because animations run inside loops, if a user forces navigation via the "BACK" button, the system triggers a `try-catch` block that queries a deeply nested property (`axes.type`). If the handle was destroyed by the router, the read fails, catching the error and silently killing the background animation thread to prevent core dumps.