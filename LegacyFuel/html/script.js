// Fuel UI Controller
class FuelUI {
    constructor() {
        this.container = document.getElementById('fuel-ui');
        this.fuelPercentage = document.getElementById('fuel-percentage');
        this.fuelFill = document.getElementById('fuel-fill');
        this.currentCost = document.getElementById('current-cost');
        this.totalCost = document.getElementById('total-cost');
        this.jerryCanInfo = document.getElementById('jerry-can-info');
        this.jerryPercentage = document.getElementById('jerry-percentage');
        
        this.isVisible = false;
        this.isRefueling = false;
        
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        // Listen for messages from the game
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            switch(data.action) {
                case 'showFuelUI':
                    this.showUI(data);
                    break;
                case 'hideFuelUI':
                    this.hideUI();
                    break;
                case 'updateFuelUI':
                    this.updateUI(data);
                    break;
            }
        });
        
        // Handle escape key to close UI
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.isVisible) {
                this.hideUI();
                this.sendNUICallback('closeFuelUI');
            }
        });
    }
    
    showUI(data) {
        this.container.classList.remove('hidden');
        this.container.classList.add('refueling');
        this.isVisible = true;
        this.isRefueling = true;
        
        // Show jerry can info if using jerry can
        if (data.usingJerryCan) {
            this.jerryCanInfo.classList.remove('hidden');
            this.updateJerryCanLevel(data.jerryCanLevel || 0);
        } else {
            this.jerryCanInfo.classList.add('hidden');
        }
        
        // Initial update
        this.updateUI(data);
    }
    
    hideUI() {
        this.container.classList.add('hidden');
        this.container.classList.remove('refueling');
        this.isVisible = false;
        this.isRefueling = false;
        this.jerryCanInfo.classList.add('hidden');
    }
    
    updateUI(data) {
        if (!this.isVisible) return;
        
        // Update fuel level
        const fuelLevel = Math.round(data.fuelLevel || 0);
        this.fuelPercentage.textContent = `${fuelLevel}%`;
        this.fuelFill.style.width = `${fuelLevel}%`;
        
        // Update fuel bar color based on level
        this.updateFuelBarColor(fuelLevel);
        
        // Update costs
        this.currentCost.textContent = `$${(data.currentCost || 0).toFixed(2)}`;
        this.totalCost.textContent = `$${(data.totalCost || 0).toFixed(2)}`;
        
        // Update jerry can level if applicable
        if (data.jerryCanLevel !== undefined) {
            this.updateJerryCanLevel(data.jerryCanLevel);
        }
    }
    
    updateFuelBarColor(level) {
        if (level < 25) {
            this.fuelFill.style.background = 'linear-gradient(90deg, #ff4444, #ff6666)';
            this.fuelFill.style.boxShadow = '0 0 10px rgba(255, 68, 68, 0.5)';
        } else if (level < 50) {
            this.fuelFill.style.background = 'linear-gradient(90deg, #ff4444, #ffaa00)';
            this.fuelFill.style.boxShadow = '0 0 10px rgba(255, 170, 0, 0.5)';
        } else if (level < 75) {
            this.fuelFill.style.background = 'linear-gradient(90deg, #ffaa00, #44ff44)';
            this.fuelFill.style.boxShadow = '0 0 10px rgba(255, 170, 0, 0.5)';
        } else {
            this.fuelFill.style.background = 'linear-gradient(90deg, #44ff44, #66ff66)';
            this.fuelFill.style.boxShadow = '0 0 10px rgba(68, 255, 68, 0.5)';
        }
    }
    
    updateJerryCanLevel(level) {
        this.jerryPercentage.textContent = `${Math.round(level)}%`;
    }
    
    sendNUICallback(action, data = {}) {
        // Send callback to Lua
        fetch(`https://${GetParentResourceName()}/${action}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data)
        });
    }
}

// Initialize the fuel UI when the page loads
document.addEventListener('DOMContentLoaded', () => {
    window.fuelUI = new FuelUI();
});

// Helper function to get parent resource name (for NUI callbacks)
function GetParentResourceName() {
    return window.location.hostname;
}