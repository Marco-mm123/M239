import {getGamesByCategory} from "./getGame.js";

const grid = document.getElementsByClassName("grid")[0] as HTMLDivElement;
const urlParams = new URLSearchParams(window.location.search);
const title = document.getElementById("title") as HTMLHeadingElement;
fillInCategory()

function fillInCategory() {
    const c = urlParams.get("c") as string;
    grid.replaceChildren()
    getGamesByCategory(c).then((games) => {
        games.forEach((game) => {
            grid.appendChild(game);
        });
    });
    document.title = c
    title.innerText = c
}