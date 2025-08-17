# mnc-LegacyFuel
# LegacyFuel

**LegacyFuel** is a simple, lightweight fuel system resource for FiveM. Initially developed by *InZidiuZ*, the script provides realistic fuel consumption mechanics suitable for GTA V roleplay servers.
<img width="1920" height="1080" alt="FiveM® by Cfx re - Midnight Club Los Santo's 13_08_2025 05_00_01" src="https://github.com/user-attachments/assets/b28033e3-673a-4f26-adb6-9f8659237189" />
- style - Basic
<img width="1920" height="1080" alt="FiveM® by Cfx re - Midnight Club Los Santo's 13_08_2025 04_53_07" src="https://github.com/user-attachments/assets/cd52152a-48ee-46de-87c7-7f14944a95bc" />
- style - BasicV2
<img width="1920" height="1080" alt="FiveM® by Cfx re - Midnight Club Los Santo's 13_08_2025 04_52_13" src="https://github.com/user-attachments/assets/b6f2bf44-2647-4411-8a24-69f6283c0975" />
<img width="1920" height="1080" alt="FiveM® by Cfx re - Midnight Club Los Santo's 13_08_2025 05_13_34" src="https://github.com/user-attachments/assets/22ad319a-7f46-45db-8eda-f33837a88baf" />

---

##  Features

- Realistic fuel consumption based on RPM  
- Fuel HUDS  
- Fueling only while outside the vehicle  
- All gas stations are interactable as pumps, with configurable blips and ui
- Usage of Jerry cans (gas can items) to refuel  
- Server-side synchronization of fuel levels  
- Optimized for low CPU usage  
- Optional randomized starting fuel for NPC/spawned vehicles 

---

##  Installation

1. **Download** the latest version from the **Code** tab on the GitHub repository.
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

These match the original design intentions and flexibility shown in community conversations.

---

##  Exports

Use the following client-side exports from other scripts:

```lua
exports["LegacyFuel"]:SetFuel(vehicle, value)  -- Set fuel level (0–100)
exports["LegacyFuel"]:GetFuel(vehicle)          -- Retrieve current fuel level

