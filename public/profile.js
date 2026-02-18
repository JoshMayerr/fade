(() => {
  const APP_STORE_URL = "https://apps.apple.com/app/id000000000";
  const openLink = document.getElementById("open-link");
  const installLink = document.getElementById("install-link");
  const nameEl = document.getElementById("profile-name");
  const timeEl = document.getElementById("profile-time");

  if (openLink) {
    openLink.href = window.location.href;
  }
  if (installLink) {
    installLink.href = APP_STORE_URL;
  }

  const parts = window.location.pathname.split("/").filter(Boolean);
  const shareId = parts.length >= 2 ? parts[1] : null;

  if (!shareId) {
    if (timeEl) timeEl.textContent = "Profile not found.";
    return;
  }

  fetch(`/api/profile/public?shareId=${encodeURIComponent(shareId)}`)
    .then((res) => res.json())
    .then((data) => {
      const displayName = data.displayName || "fade friend";
      if (nameEl) nameEl.textContent = displayName;
      if (data.startAt) {
        const date = new Date(data.startAt);
        const formatted = date.toLocaleDateString(undefined, {
          year: "numeric",
          month: "long",
          day: "numeric",
        });
        if (timeEl) timeEl.textContent = `free since ${formatted}`;
      } else if (timeEl) {
        timeEl.textContent = "has not started yet.";
      }
    })
    .catch(() => {
      if (timeEl) timeEl.textContent = "Profile not found.";
    });
})();
