(function () {
    const canvas = document.getElementById("salesChart");
    if (!canvas || typeof Chart === "undefined") {
        return;
    }

    let labels = [];
    let values = [];

    try {
        labels = JSON.parse(canvas.dataset.labels || "[]");
        values = JSON.parse(canvas.dataset.values || "[]");
    } catch (error) {
        console.error("Unable to load dashboard chart data.", error);
        return;
    }

    new Chart(canvas, {
        type: "line",
        data: {
            labels: labels,
            datasets: [{
                label: "Sales Without Tax ₹",
                data: values,
                tension: 0.3,
                fill: false
            }]
        },
        options: {
            responsive: true
        }
    });
})()