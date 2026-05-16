# 📝 ToDoList - HarmonyOS To-Do Application

A light-weight and efficient To-Do application built with **HarmonyOS** and **ArkTS**. Designed to help you efficiently organize daily routines and manage tasks with seamless precision.

## ✨ Features

### 🆕 Core Functionalities

| Feature | Description |
| :--- | :--- |
| 📌 **Dynamic Task Insertion** | Append new tasks seamlessly on the fly by keying in details and specifying appropriate due dates. |
| 📜 **Full-Screen Scrollable List** | Fluidly navigate large workloads with smooth scrolling. Features a native physical spring-back edge effect when reaching list margins. |
| ✅ **Prioritized Complete Sorting** | A state-driven reactive sorting mechanism that automatically moves completed tasks to the top of the list for quick evaluation. |
| 🕐 **Timestamp Logging** | Instantly records and displays exact completion timestamps down to the minute (e.g., `✓ Completed at: 2026-05-16 16:12`) upon marking a task done. |
| ⏰ **Due Date Reminder** | Enforce milestones by mapping a deadline picker to each task. Overdue unfinished tasks automatically fire high-contrast crimson alerts and active system toasts. |

### 🎨 Design Highlights

- **Declarative UI**: Engineered entirely via the ArkUI framework, relying on dual-way data state bindings to trigger real-time, zero-latency visual redrawing.
- **Polished Interaction**: Native animations for multi-row scanning, checkbox toggling, and dialog invitations are heavily tuned for maximum responsiveness.
- **Skeuomorphic Polishing**: Crafted with spatial card container padding, sub-pixel soft drop shadows, and contextual notification alerts to maximize modern interface aesthetic.
- **Lightweight Dependency**: Zero reliance on heavy multi-tier external libraries, making it highly secure and fully compatible with native compilation tools.

---

## 📂 Project Directory

```text
ToDoList/
├── AppScope/                 # Global application resource container
│   ├── app.json5             # Application configuration (bundle names, app versions)
│   └── resources/            # Universal graphics, strings, and multi-language assets
├── entry/                    # Main runtime orchestration module
│   └── src/main/
│       ├── ets/              # ArkTS source root file tree
│       │   ├── entryability/ # UIAbility lifecycle event handlers
│       │   ├── pages/        # Main structural UI entry point (ToDoListPage)
│       │   ├── view/         # Modular child views (individual ToDoItem card layout)
│       │   └── viewmodel/    # Object relations, state configurations & DataModel layer
│       ├── resources/        # Local parameters (color tables, local strings, floats)
│       └── module.json5      # Module definitions and platform access configurations
├── build-profile.json5       # Project-level build rules and compiler target mappings
├── hvigorfile.ts             # Automated build orchestration execution pipeline
├── oh-package.json5          # OpenHarmony package manifest definition
└── .gitignore                # Version control ignore definitions
```

---

## 🚀 Quick Start

### 💻 Environment Requirements

- **Target Hardware**: Physical Huawei mobile device supporting Standard System or official DevEco Emulator.
- **Integrated Development Environment**: DevEco Studio 6.0.2 Release or newer.
- **HarmonyOS SDK**: HarmonyOS 6.0.2 Release SDK (API Level 22) or newer.
- **Base OS Environment**: HarmonyOS 5.0.5 Release or newer.

### 🛠️ Configuration and Deployment

1. **Clone the Repository**
   ```bash
   git clone <your-repository-url-here>
   ```

2. **Open the Project Directory in DevEco Studio**
    - Launch DevEco Studio, hit **File** → **Open**.
    - Direct the path selector to the root `ToDoList/` folder and wait for automated package resolution to complete.

3. **Configure Automatic Signatures**
    - Go to the primary menu bar, click **File** → **Project Structure**.
    - Navigate down to **Project** → **Signing Configs**.
    - Check the **Automatically generate signature** checkbox and let the background service finish credential pairing.

4. **Compile and Execute**
    - Confirm a development handset is linked with ADB debugging enabled, or an active emulator is initialized via `Device Manager`.
    - Click the green triangular play button ▶ (**Run**) embedded along the header taskbar.
    - The building architecture tool `Hvigor` will initiate binary bundling, pack the app, and install it on the target screen.

---

## 📖 Operational Guide

### 1. Dynamic Task Entry
- At the header input zone, type your task description within the provided text entry row.
- Tap the **Select Date** option to spin up the system's native multi-axis wheel date selector to establish your target milestone.
- Press **Add** to inject the newly minted item block directly into the reactive queue.

### 2. Task State Control
- **Checking a Task**: Tap any task card container. The passive bounding circle smoothly flips into a brilliant blue check mark icon, while the label content adopts a elegant line-through style and a dimmed alpha value.
- **Sorting Execution**: Done items automatically slide forward to occupy the top spots in the list. Meanwhile, an informative string highlighting the precise modification date appears beneath the item body.
- **Overdue Detection**: Any expired task caught during boot-up loops launches immediate Toast alerts, turning task headers red accompanied by high-contrast "Overdue" status tags.

### 3. List Navigation
- When the task count surpasses viewport dimensions, perform vertical finger swipes to pan through the interface effortlessly.
- Boundary endpoints feature a highly-tuned physical tension mechanic, bringing a smooth spring-back cushioning visual on overflow stretches.

---

## 🧩 Core Implementation Details

### ⚙️ Strongly-Typed Data Interface (DataModel.ets)
Tasks are mapped onto defined object models rather than primitive text rows to handle status variations accurately:
```typescript
/**
 * Interface mapping for a single To-Do entity
 */
export interface TaskItem {
  id: string;             // Cryptographically distinct random token
  content: string;        // Principal text body describing the chore
  isComplete: boolean;    // Binary toggle signifying completion status
  completionTime: string; // Clock capture recording resolution events
  dueDate: string;        // Assigned milestone threshold (YYYY-MM-DD)
}
```

### 🎛️ Strategic Priority Sorting Logic (ToDoListPage.ets)
An active weighting evaluation runs behind state changes to pull processed entries to the top:
```typescript
sortTasks() 
{
  this.totalTasks.sort((a, b) => {
    if (a.isComplete && !b.isComplete) return -1; // Give prioritized weight to finished rows
    if (!a.isComplete && b.isComplete) return 1;
    return 0;
  });
}
```
