let count = 0;

const countElement = document.getElementById("count");

const increaseButton =
    document.getElementById("increase");

const decreaseButton =
    document.getElementById("decrease");

const resetButton =
    document.getElementById("reset");

const statusButton =
    document.getElementById("statusButton");

const statusElement =
    document.getElementById("status");


increaseButton.addEventListener("click", () => {

    count++;

    countElement.textContent = count;

});


decreaseButton.addEventListener("click", () => {

    count--;

    countElement.textContent = count;

});


resetButton.addEventListener("click", () => {

    count = 0;

    countElement.textContent = count;

});


statusButton.addEventListener("click", async () => {

    statusElement.textContent =
        "Checking application...";

    try {

        const response =
            await fetch("/health");

        const data =
            await response.json();

        statusElement.textContent =
            `Status: ${data.status} | Application: ${data.application} | Version: ${data.version}`;

    } catch (error) {

        statusElement.textContent =
            "Application health check failed.";

    }

});
