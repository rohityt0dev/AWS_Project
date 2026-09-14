const menuBtn = document.getElementById("menuBtn");
const nav = document.getElementById("nav");
const topBtn = document.getElementById("topBtn");

menuBtn.addEventListener("click", () => {
  nav.classList.toggle("open");
});

document.querySelectorAll("#nav a").forEach(link => {
  link.addEventListener("click", () => nav.classList.remove("open"));
});

window.addEventListener("scroll", () => {
  topBtn.style.display = window.scrollY > 500 ? "block" : "none";
});

topBtn.addEventListener("click", () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
});
