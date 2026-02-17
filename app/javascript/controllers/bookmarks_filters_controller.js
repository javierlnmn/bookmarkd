import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchbar", "tag", "bookmark", "folder"];

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

  tagsFilter() {
    const selectedTagNames = this.tagTargets
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.dataset.tagName);

    if (selectedTagNames.length <= 0) {
      this.bookmarkTargets.forEach((bm) => bm.classList.remove("hidden"));
      return;
    }

    const bookmarks = this.bookmarkTargets.map((bm) => ({
      bookmarkRef: bm,
      tags: [
        ...bm
          .querySelector("div.flex.flex-wrap.gap-2.relative")
          .querySelectorAll('[id$="bookmark_tag"]'),
      ].map(
        (tagEl) =>
          tagEl.querySelector("span.text-xs.font-semibold.truncate").innerText,
      ),
    }));

    for (const bm of bookmarks) {
      if (!bm.tags.some((tag) => selectedTagNames.includes(tag))) {
        bm.bookmarkRef.classList.add("hidden");
      } else {
        bm.bookmarkRef.classList.remove("hidden");
      }
    }
  }

  tagsReset() {
    this.tagTargets.forEach((tagCb) => {
      tagCb.checked = false;
    });

    this.tagsFilter();
  }
}
