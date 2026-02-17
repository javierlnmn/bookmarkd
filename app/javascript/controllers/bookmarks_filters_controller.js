import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchbar", "bookmark", "folder"];

  searchbar() {
    const value = this.searchbarTarget.value;

    const bookmarks = this.bookmarkTargets.map((bm) => ({
      bookmarkRef: bm,
      name: bm.querySelector("h3.font-bold").innerText,
      description: bm.querySelector("p.text-xs.font-medium.text-zinc-500")
        .innerText,
    }));

    const folders = this.folderTargets.map((bm) => ({
      folderRef: bm,
      name: bm.querySelector("h3.font-bold").innerText,
      description: bm.querySelector("p.text-xs.font-medium.text-zinc-500")
        .innerText,
    }));

    for (const bm of bookmarks) {
      if (
        !bm.name.toLowerCase().includes(value.toLowerCase()) &&
        !bm.description.toLowerCase().includes(value.toLowerCase())
      ) {
        bm.bookmarkRef.classList.add("hidden");
      } else {
        bm.bookmarkRef.classList.remove("hidden");
      }
    }

    for (const fo of folders) {
      if (
        !fo.name.toLowerCase().includes(value.toLowerCase()) &&
        !fo.description.toLowerCase().includes(value.toLowerCase())
      ) {
        fo.folderRef.classList.add("hidden");
      } else {
        fo.folderRef.classList.remove("hidden");
      }
    }
  }
}
