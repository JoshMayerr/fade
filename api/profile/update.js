const { sql } = require("../_db");
const { readJson, sendJson, methodNotAllowed } = require("../_utils");
const { getBearerToken, getProfileByToken } = require("../_auth");

module.exports = async (req, res) => {
  if (req.method !== "PATCH") {
    return methodNotAllowed(res);
  }

  let body = null;
  try {
    body = await readJson(req);
  } catch {
    return sendJson(res, 400, { error: "invalid_json" });
  }

  const token = getBearerToken(req);
  const profile = await getProfileByToken(token);

  if (!profile) {
    return sendJson(res, 401, { error: "unauthorized" });
  }

  const displayName =
    typeof body?.displayName === "string" && body.displayName.trim()
      ? body.displayName.trim().slice(0, 32)
      : null;

  await sql`
    update profiles
    set display_name = ${displayName}
    where id = ${profile.id}
  `;

  return sendJson(res, 200, { ok: true, displayName });
};
