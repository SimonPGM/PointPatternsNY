(function () {
    const sliders = [...document.querySelectorAll(".inner__matrix")];
    const arrowNext = document.querySelector("#after");
    const arrowBefore = document.querySelector("#before");
    const currentInner = document.querySelector(".matrix");
    let value;
    let out = true;

    arrowNext.addEventListener("click", () => changePosition(1, true));
    arrowBefore.addEventListener("click", () => changePosition(-1, true));
    setInterval(() => changePosition(1), 5000);
    currentInner.addEventListener("mouseenter", () => {
        out = false;
    });
    currentInner.addEventListener("mouseleave", () => {
        out = true;
    });


    function changePosition(change, click = false) {
        if (out || click) {
            const currentElement = Number(document.querySelector(".show").dataset.id) - 1;

            value = currentElement;
            value += change;
            value %= sliders.length;
            value = value < 0 ? value + sliders.length : value;

            sliders[value].classList.toggle("show");
            sliders[currentElement].classList.toggle("show");
        }
    }

})()

