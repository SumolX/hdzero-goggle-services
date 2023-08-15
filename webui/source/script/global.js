function hideElement(element) {
    element.classList.toggle("display-block");
}

function returnFromLogin() {
    window.location = '/index.html';
}

function displayError(errMessage) {
    const dialog = document.getElementById("dialog");
    const dbuttons = document.getElementById("d-buttons");
    document.getElementById("d-title").innerHTML = "Error";
    document.getElementById("d-message").innerHTML = errMessage;

    const btn1 = document.createElement("button");
    btn1.innerHTML = "OK"
    btn1.onclick = function () {
        hideElement(dialog);
    }

    dbuttons.appendChild(btn1);
    dialog.style.display = "block";
}

function getAuthorization() {
    let pswd = "";
    if (document.getElementById("pswd")) {
        pswd = document.getElementById("pswd").value;
    }

    const settings = {
        method: 'POST',
        headers: {
            Accept: 'application/json',
            'Content-Type': 'application/json',
        }
    };

    fetch('/cgi-bin/status?authenticate=' + pswd, settings).then(res => {
        if (!res.ok) {
            let err = new Error("http status code: " + res.status);
            err.response = res;
            err.status = res.status;
            throw err
        }
        returnFromLogin();
    })
        .catch((err) => {
            displayError(err.message);
        });
}

