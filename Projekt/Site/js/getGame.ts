interface Game {
    title: string;
    developer: string;
    releaseYear: number;
    image: string;
}

interface Category {
    name: string;
    games: Game[];
}

async function getData(): Promise<Category[]> {
    const response = await fetch('./data/categories.json');
    return await response.json();
}

async function getGamesByCategory(category: string): Promise<HTMLElement[]> {
    const foundCategory = (await getData()).find(c => c.name === category);
    if (foundCategory === undefined) {
        return [];
    }
    return foundCategory.games.map(g => getHtmlFromData(g));
}

async function getRandomGame(): Promise<HTMLElement> {
    const categories = await getData();
    const randCategory = categories[Math.floor(Math.random() * categories.length)];
    const randGame = randCategory.games[Math.floor(Math.random() * randCategory.games.length)];
    return getHtmlFromData(randGame)
}

function getHtmlFromData(game: Game): HTMLElement {
    const li = document.createElement('li');
    li.classList.add('recommendation');
    const fig = document.createElement('figure');
    const imageWrapper = document.createElement('div');
    imageWrapper.classList.add('recommendation-img-wrapper');
    const img = document.createElement('img');
    img.classList.add('recommendation-img');
    img.src = game.image;
    imageWrapper.appendChild(img);
    const info = document.createElement('figcaption');
    info.classList.add('recommendation-info');
    const title = document.createElement('b');
    title.innerText = game.title;
    const developer = document.createElement('span');
    developer.innerText = game.developer + ' - ' + game.releaseYear;
    info.appendChild(title);
    info.appendChild(developer);
    fig.appendChild(imageWrapper);
    fig.appendChild(info);
    li.appendChild(fig);
    return li;
}

export { getRandomGame, getGamesByCategory, getData };