import {getData} from "./getGame.js";

const search = document.getElementById("searchbar") as HTMLInputElement;
const results = document.getElementsByClassName("results")[0] as HTMLElement;

search.onkeyup = async () => {
    const input = search.value;
    const names = (await getData()).map(c => c.name);
    const filteredNames = names.filter(n => n.toLowerCase().includes(input.trim().toLowerCase()) && input.trim() !== "");
    if (filteredNames.length !== 0) {
        results.replaceChildren()
        filteredNames.forEach(name => {
            const result = document.createElement("li");
            const resultLink = document.createElement("a");
            resultLink.href = "category.html?c=" + name;
            resultLink.innerText = name;
            result.classList.add("result");
            result.appendChild(resultLink);
            results.appendChild(result);
        });
        results.style.display = "block";
    } else {
        results.style.display = "none";
    }


}