let cardName = document.querySelector(".cardName");
let cardNumber = document.querySelector(".cardNumber");
let cardMonth = document.querySelector(".cardMonth");
let cardYear = document.querySelector(".cardYear");
let cardCVC = document.querySelector(".cardCVC");

let errorLabelForName = document.querySelector(".errorForName");
let errorLabelForNumber = document.querySelector(".errorForNumber");
let errorLabelForMonth = document.querySelector(".errorForMonth");
let errorLabelForYear = document.querySelector(".errorForYear");
let errorLabelForCVC = document.querySelector(".errorForCVC");

let errorLabels = document.querySelectorAll(".errorLabel");
let inputs = document.querySelectorAll(".form-control");
let invalidfeedbacks = document.querySelectorAll(".invalid-feedback");

let submitCard = document.querySelector(".submitCard");

errorLabels.forEach(function (label) {
    label.style.color = "darkred";
    label.style.fontSize = "0.8em";
});

cardName.addEventListener('keyup', function (event) {
    let letters = /^[A-Za-z]+$/;
    invalidfeedbacks.forEach(function (label) {
        label.innerText = ""
    });
    if (!this.value.match(letters)) {
        errorLabelForName.innerText = "You can only enter letters";
        this.style.marginBottom = "0";

    }
    else if (this.value.length < 3) {
        errorLabelForName.innerText = "Length must be a least 3";
        this.style.marginBottom = "0";
    }else {
        errorLabelForName.innerText = "";
        this.style.marginBottom = "1em";
    }
})

cardNumber.addEventListener('keyup', function (event) {
    invalidfeedbacks.forEach(function (label) {
        label.innerText = ""
    });
    if (isNaN(this.value)) {
        errorLabelForNumber.innerText = "Card number must be digits";
        this.style.marginBottom = "0";
    }
    else if (this.value.length != 16) {
        errorLabelForNumber.innerText = "Length must be 16";
        this.style.marginBottom = "0";
    }else {
        errorLabelForNumber.innerText = "";
        this.style.marginBottom = "1em";
    }
})

let yearsValue = "";
cardYear.addEventListener('keyup', function (event) {
    invalidfeedbacks.forEach(function (label) {
        label.innerText = ""
    });
    let d = new Date();
    let y = d.getFullYear();
    yearsValue = this.value;
    if (isNaN(this.value)) {
        errorLabelForYear.innerText = "Year must be digits";
        this.style.marginBottom = "0";
    }
    else if (this.value < y) {
        errorLabelForYear.innerText = `Year cannot less than ${y} `;
        this.style.marginBottom = "0";
    }else {
        errorLabelForYear.innerText = "";
        this.style.marginBottom = "1em";
    }
})

cardMonth.addEventListener('keyup', function (event) {
    invalidfeedbacks.forEach(function (label) {
        label.innerText = ""
    });
    let d = new Date();
    let m = d.getMonth();
    if (isNaN(this.value)) {
        errorLabelForMonth.innerText = "Month must be digits";
        this.style.marginBottom = "0";
    }
    else if (this.value > 12 || this.value < 1) {
        errorLabelForMonth.innerText = "Month must be less than 12 and greater than 0";
        this.style.marginBottom = "0";
    } else if (yearsValue == 2020 && this.value - 1 < m) {
        errorLabelForMonth.innerText = "Cannot enter previous months";
        this.style.marginBottom = "0";
    }else {
        errorLabelForMonth.innerText = "";
        this.style.marginBottom = "1em";
    }
})

cardCVC.addEventListener('keyup', function (event) {
    invalidfeedbacks.forEach(function (label) {
        label.innerText = ""
    });
    if (isNaN(this.value)) {
        errorLabelForCVC.innerText = "CVC must be digits";
        this.style.marginBottom = "0";
    }else if (this.value.length != 3) {
        errorLabelForCVC.innerText = "Length must be 3";
        this.style.marginBottom = "0";
    }else {
        errorLabelForCVC.innerText = "";
        this.style.marginBottom = "1em";
    }
})

inputs.forEach(function (input) {
    input.addEventListener("keyup", function () {
        for (var i = 0; i < errorLabels.length; i++) {
            if (errorLabels[i].innerText != "") {
                console.log("disabled")
                submitCard.disabled = true
                break
            }
            else {
                submitCard.disabled = false
            }
        }
    })
});

