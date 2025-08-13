# mnc-LegacyFuel
# LegacyFuel

**LegacyFuel** is a simple, lightweight fuel system resource for FiveM. Initially developed by *InZidiuZ*, the script provides realistic fuel consumption mechanics suitable for GTA V roleplay servers. :contentReference[oaicite:0]{index=0}

---

##  Features

- Realistic fuel consumption based on RPM  
- Fuel HUDS  
- Fueling only while outside the vehicle  
- All gas stations are interactable as pumps, with configurable blips and ui
- Usage of Jerry cans (gas can items) to refuel  
- Server-side synchronization of fuel levels  
- Optimized for low CPU usage  
- Optional randomized starting fuel for NPC/spawned vehicles :contentReference[oaicite:2]{index=2}  

---

##  Installation

1. **Download** the latest version from the **Code** tab on the GitHub repository. :contentReference[oaicite:3]{index=3}  
2. **Move** the `LegacyFuel` folder into your server’s `resources` directory.  
3. **Configure** settings in the `config.lua` (e.g., enable blips, adjust fuel settings).  
4. **Add** the following line to your `server.cfg`:

    ```
    start LegacyFuel
    ```
   
5. **Restart** your server to apply changes.

---

##  Configuration

All behavior can be tweaked via `config.lua`. For example, you may:

- Enable or disable gas station blips  
- Adjust fuel consumption rate  
- Set specific behavior for engine failure or low fuel  

These match the original design intentions and flexibility shown in community conversations. :contentReference[oaicite:4]{index=4}

---

##  Exports

Use the following client-side exports from other scripts:

```lua
exports["LegacyFuel"]:SetFuel(vehicle, value)  -- Set fuel level (0–100)
exports["LegacyFuel"]:GetFuel(vehicle)          -- Retrieve current fuel level

