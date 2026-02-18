const readJson = async (req) => {
  return new Promise((resolve, reject) => {
    let data = "";
    req.on("data", (chunk) => {
      data += chunk;
    });
    req.on("end", () => {
      if (!data) {
        resolve(null);
        return;
      }
      try {
        resolve(JSON.parse(data));
      } catch (error) {
        reject(error);
      }
    });
  });
};

const sendJson = (res, status, payload) => {
  res.statusCode = status;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Cache-Control", "no-store");
  res.end(JSON.stringify(payload));
};

const methodNotAllowed = (res) => sendJson(res, 405, { error: "method_not_allowed" });

const getUrl = (req) => {
  return new URL(req.url, `https://${req.headers.host || "fade.cool"}`);
};

module.exports = {
  readJson,
  sendJson,
  methodNotAllowed,
  getUrl,
};
