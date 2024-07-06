const songList = document.querySelector(".songList");
const AlbumTitle = document.querySelector("#albumTitle");
const ReleaseDate = document.querySelector("#releaseDate");
const searchParams = new URLSearchParams(window.location.search);
const AlbumId = Number(searchParams.get("id"));
const AlbumCover = document.querySelector("#albumCover");
const AlbumDescription = document.querySelector("#albumCaption")
const About = document.querySelector("#aboutText");

async function getData() {
    const response = await fetch("../Site/data/data.json");
    return await response.json();
}

getData().then(data => {
    const Album = data.albums[AlbumId];

    for (const song of Album.songs) {
        const listObject = document.createElement("tr");

        const songName = document.createElement("td");
        const Listens = document.createElement("td");
        const Length = document.createElement("td");

        songName.innerText = song.title;
        Listens.innerText = song.listens;
        Length.innerText = song.length;

        listObject.appendChild(songName);
        listObject.appendChild(Listens);
        listObject.appendChild(Length);

        songList.appendChild(listObject);
    }

    AlbumTitle.innerText = Album.title;
    ReleaseDate.innerText = Album.release_date;
    AlbumCover.src = Album.cover;
    AlbumDescription.innerText = "Album Cover von " + Album.title;
    About.innerText = Album.description;
});