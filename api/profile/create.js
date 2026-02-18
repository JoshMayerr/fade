const { sql } = require("../_db");
const { readJson, sendJson, methodNotAllowed } = require("../_utils");
const { randomToken } = require("../_tokens");

const MAX_ATTEMPTS = 5;

module.exports = async (req, res) => {
  if (req.method !== "POST") {
    return methodNotAllowed(res);
  }

  let body = null;
  try {
    body = await readJson(req);
  } catch {
    return sendJson(res, 400, { error: "invalid_json" });
  }

  const displayName =
    typeof body?.displayName === "string" && body.displayName.trim()
      ? body.displayName.trim().slice(0, 32)
      : null;

  let created = null;

  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt += 1) {
    const shareId = randomToken(12);
    const writeToken = randomToken(24);
    try {
      const { rows } = await sql`
        insert into profiles (share_id, write_token, display_name)
        values (${shareId}, ${writeToken}, ${displayName})
        returning id, share_id, write_token
      `;
      created = rows[0];
      break;
    } catch (error) {
      if (!`${error}`.includes("unique")) {
        throw error;
      }
    }
  }

  if (!created) {
    return sendJson(res, 500, { error: "could_not_create_profile" });
  }

  return sendJson(res, 201, {
    profileId: created.id,
    shareId: created.share_id,
    writeToken: created.write_token,
  });
};
