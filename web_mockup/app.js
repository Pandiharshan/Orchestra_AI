const AppConfig = {
    baseUrl: 'http://127.0.0.1:8000'
};

const state = {
    user: null,
    goal: '',
    isRunning: false,
    agents: [
        { id: 'research', name: 'Research', emoji: '🔍', status: 'waiting' },
        { id: 'planner', name: 'Planner', emoji: '📅', status: 'waiting' },
        { id: 'writer', name: 'Writer', emoji: '✍️', status: 'waiting' },
        { id: 'coder', name: 'Coder', emoji: '💻', status: 'waiting' },
        { id: 'reviewer', name: 'Reviewer', emoji: '✅', status: 'waiting' }
    ]
};

// UI Elements
const authView = document.getElementById('auth-view');
const dashboardView = document.getElementById('dashboard-view');
const loginForm = document.getElementById('login-form');
const logoutBtn = document.getElementById('logout-btn');
const orchestrateBtn = document.getElementById('orchestrate-btn');
const goalInput = document.getElementById('goal-input');
const executionView = document.getElementById('execution-view');
const statusText = document.getElementById('status-text');
const loader = document.getElementById('loader');
const resultsPanel = document.getElementById('results-panel');
const finalResultText = document.getElementById('final-result-text');

// Authentication
loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        const res = await fetch(`${AppConfig.baseUrl}/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        if (res.ok) {
            const data = await res.json();
            state.user = data.user;
            showView('dashboard');
        } else {
            alert('Login failed. Use user@example.com / password');
        }
    } catch (err) {
        console.error(err);
        alert('Backend connection error. Is it running?');
    }
});

logoutBtn.addEventListener('click', () => {
    state.user = null;
    showView('auth');
});

function showView(view) {
    authView.classList.toggle('hidden', view === 'dashboard');
    dashboardView.classList.toggle('hidden', view === 'auth');
}

// Orchestration
orchestrateBtn.addEventListener('click', async () => {
    const goal = goalInput.value.trim();
    if (!goal || state.isRunning) return;

    state.goal = goal;
    state.isRunning = true;
    
    // UI Reset
    executionView.classList.remove('hidden');
    resultsPanel.classList.add('hidden');
    statusText.innerText = '🎼 Orchestrating agents on backend...';
    loader.classList.remove('hidden');
    resetAgents();

    try {
        // Step 1: Start orchestration
        const res = await fetch(`${AppConfig.baseUrl}/execute-goal`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ goal })
        });

        if (res.ok) {
            const data = await res.json();
            
            // Simulate agent progression in sync with backend logic
            await runAgentSimulation(data);

            // Final Result
            state.isRunning = false;
            loader.classList.add('hidden');
            statusText.innerText = 'Complete. Final result ready.';
            finalResultText.innerText = data.final_result;
            resultsPanel.classList.remove('hidden');
            resultsPanel.scrollIntoView({ behavior: 'smooth' });

        } else {
            throw new Error('Orchestration failed');
        }
    } catch (err) {
        console.error(err);
        state.isRunning = false;
        loader.classList.add('hidden');
        statusText.innerText = 'Error: ' + err.message;
    }
});

async function runAgentSimulation(data) {
    const agentOutputs = data.agent_outputs;
    
    for (let i = 0; i < state.agents.length; i++) {
        const agent = state.agents[i];
        updateAgentUI(agent.id, 'active');
        statusText.innerText = `Agent: ${agent.name} is working...`;
        
        await new Promise(r => setTimeout(r, 1500)); // Visual delay
        
        updateAgentUI(agent.id, 'done');
    }
}

function updateAgentUI(id, status) {
    const card = document.querySelector(`[data-agent="${id}"]`);
    const statusLabel = card.querySelector('.agent-status');
    
    card.classList.remove('active', 'done');
    if (status !== 'waiting') {
        card.classList.add(status);
        statusLabel.innerText = status.charAt(0).toUpperCase() + status.slice(1);
    } else {
        statusLabel.innerText = 'Waiting';
    }
}

function resetAgents() {
    state.agents.forEach(a => updateAgentUI(a.id, 'waiting'));
}

// Chips integration
document.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', () => {
        goalInput.value = 'I want to: ' + chip.innerText;
    });
});
