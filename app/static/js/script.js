console.log("SMR Sales Management System loaded.");

(() => {
  const launcher = document.getElementById("aiAssistantLauncher");
  const panel = document.getElementById("aiAssistantPanel");
  if (!launcher || !panel) return;

  const closeButton = document.getElementById("aiAssistantClose");
  const form = document.getElementById("aiAssistantForm");
  const input = document.getElementById("aiAssistantInput");
  const messages = document.getElementById("aiAssistantMessages");

  function setOpen(open) {
    panel.hidden = !open;
    launcher.setAttribute("aria-expanded", String(open));
    if (open) input.focus();
  }

  function addMessage(text, type) {
    const message = document.createElement("div");
    message.className = `ai-message ai-message-${type}`;
    message.textContent = text;
    messages.appendChild(message);
    messages.scrollTop = messages.scrollHeight;
    return message;
  }

  launcher.addEventListener("click", () => setOpen(panel.hidden));
  closeButton.addEventListener("click", () => setOpen(false));

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const message = input.value.trim();
    if (!message) return;

    addMessage(message, "user");
    input.value = "";
    input.disabled = true;
    const sendButton = form.querySelector("button");
    sendButton.disabled = true;
    const loading = addMessage("Thinking...", "bot");

    try {
      const response = await fetch("/api/assistant/chat", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({message})
      });
      const data = await response.json();
      loading.remove();
      if (!response.ok) {
        addMessage(data.error || "The assistant could not respond.", "error");
      } else {
        addMessage(data.answer || "No response was returned.", "bot");
      }
    } catch (error) {
      loading.remove();
      addMessage("Network error. Please try again.", "error");
    } finally {
      input.disabled = false;
      sendButton.disabled = false;
      input.focus();
    }
  });
})();
