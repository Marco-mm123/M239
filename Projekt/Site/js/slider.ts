import {getRandomGame} from "./getGame.js";



const slidesContainer = document.getElementById("slides-container") as HTMLDivElement;

fillInSlider()

const slide = document.querySelector(".recommendation") as HTMLElement;
const prevButton = document.getElementById("slide-arrow-prev") as HTMLButtonElement;
const nextButton = document.getElementById("slide-arrow-next") as HTMLButtonElement;

nextButton.addEventListener("click", (event) => {
    const slideWidth = slide.clientWidth;
    slidesContainer.scrollLeft += slideWidth;
});

prevButton.addEventListener("click", () => {
    const slideWidth = slide.clientWidth;
    slidesContainer.scrollLeft -= slideWidth;
});

function fillInSlider() {
    for (let i = 0; i < 5; i++) {
        getRandomGame().then((game) => {
            slidesContainer.appendChild(game);
        });
    }
}