# Auto Pet Battler

This Lua script is for a Roblox-based auto-battle system.

## 🧠 How It Works

- You click a wild monster to start.
- Your pet automatically fights it.
- After that monster is defeated, the pet continues fighting the rest, one by one.

## 📦 Requirements

- A model named **`Pet`** in `Workspace`
- A folder named **`WildMons`** in `Workspace`
  - Each monster should be a Model with:
    - `Humanoid`
    - `ClickDetector` (or it will be added automatically)

## 🛠️ How to Use

1. Paste the `AutoPetBattler.lua` script into a **ServerScript** in `ServerScriptService`.
2. Set up your `WildMons` folder with monster models.
3. Click one monster — your pet will do the rest!

---

### ✅ License

You’re free to use this in student/university projects, games, or prototypes.
