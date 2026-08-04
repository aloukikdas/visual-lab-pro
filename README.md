# VISUAL LAB PRO 🧪⚡
**An Interactive Engineering & STEM Virtual Laboratory built entirely in Scilab 6.**

Visual Lab Pro is a modern, modular, single-page application (SPA) designed to bring abstract mathematical and engineering concepts to life. By aggressively pushing the boundaries of Scilab's Java Swing and OpenGL graphics engines, this project delivers a highly polished, interactive, and animated educational experience.

## 🚀 Core Features

* **Custom Routing Engine:** Implements a custom virtual router (`navigate_to`) to destroy and reconstruct UI modules dynamically, mimicking modern web frameworks without crashing the Scilab memory heap.
* **Pure Dark Theme:** Overrides Scilab's default gray Java Swing UI with a highly customized, layered Dark Mode, utilizing normalized coordinates for perfect scaling.
* **Thread-Safe Animations:** Uses finite-pulse loops and `sleep()` yielding to run real-time 60FPS animations without starving Scilab's single-threaded UI event queue.
* **Smart Data-Tips:** Hijacks default OpenGL polyline events with a custom formatting engine to display real-world units (e.g., "Voltage", "Current", "₹ in Lakhs") dynamically.

## 🔬 The Laboratories

### 1. Circuit Lab (DC Analysis)
* **Procedural Geometry:** The circuit schematic is not an image; it is mathematically drawn. The zig-zag resistor is generated procedurally using the sine wave function $y = 4.0 + 0.3 \times \sin(\frac{2\pi}{0.4} \times (x - 4.2))$ to map electron coordinates perfectly to the visual line.
* **RGB Power Mapping:** The UI calculates absolute power dissipation ($P = V \times I$) and dynamically scales the RGB background matrix of the bulb marker to visually represent brightness.
* **Finite Pulse Simulation:** Safely navigates UI lockups by running a timed animation burst that visually flows electrons through the schematic while allowing real-time slider adjustments.

### 2. Physics Lab (Projectile Motion)
* **Algorithmic Predictive Tracing:** Uses background math calculations to instantly draw a dashed magenta trajectory preview before the user even launches the projectile.
* **Smart Apex Tracking:** Algorithmically finds the maximum height array index and automatically spawns an interactive OpenGL datatip directly on the peak of the curve.

### 3. Finance & Analytics Labs
* **Dynamic Rescaling:** Automatically divides massive numbers (removing ugly `e06` scientific notation) and maps them to clean integer axes labeled appropriately.
* **Real-time Data Mutation:** Mutates array data within the handle memory (`VLP_CONTEXT`) instantly on slider callbacks to eliminate heavy UI redraws.

## 🛠️ Technical Limitations Overcome
During development, we encountered a known limitation in Scilab 6: mixing Java Swing (UI components) and OpenGL (Graphs) causes "staircase" rendering flickers. 
* Double-buffering (`immediate_drawing = "off"`) smooths the graphs but breaks the Java background layer, exposing a white canvas. 
* **Our Solution:** We prioritized a flawless, persistent dark theme over immediate drawing. The slight sequential load-in of elements is a deliberate architectural choice to force the Java/OpenGL bridge to respect the dark canvas hierarchy. 

## ⚙️ How to Run
1. Open Scilab 6.x.
2. Set your working directory to the `visual-lab-pro` root folder.
3. Run `exec("src/main.sce");`

---

## 👨‍💻 Author

**Aloukik Das**
* **GitHub:** [https://github.com/yourusername](https://github.com/aloukikdas)
* **LinkedIn:** [https://www.linkedin.com/in/aloukik-das-0a8685304](https://www.linkedin.com/in/aloukik-das-0a8685304)
* **Project Link:** [https://github.com/aloukikdas/visual-lab-pro](https://github.com/aloukikdas/visual-lab-pro)

## 🏆 Acknowledgements
Developed for the **FOSSEE Scilab GUIVerse Hackathon 2026**. 

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
