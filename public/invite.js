(() => {
  const APP_STORE_URL = "https://apps.apple.com/app/id000000000";
  const openLink = document.getElementById("open-link");
  const installLink = document.getElementById("install-link");

  if (openLink) {
    openLink.href = window.location.href;
  }
  if (installLink) {
    installLink.href = APP_STORE_URL;
  }
})();
