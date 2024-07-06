"use strict";
const title = document.getElementById("title");
const desc = document.getElementById("desc");
const urlParams = new URLSearchParams(window.location.search);
fillInText();
function fillInText() {
    if (urlParams.get("action") === "success") {
        title.innerText = "Erfolgreich registriert";
        desc.innerText = "Vielen Dank für deine Registrierung. Du kannst dich jetzt einloggen und die Steem-Community entdecken.";
    }
    else if (urlParams.get("action") === "reset") {
        title.innerText = "Passwort zurückgesetzt";
        desc.innerText = "Sie können jetzt Ihr neues Passwort verwenden, um sich anzumelden.";
    }
}
