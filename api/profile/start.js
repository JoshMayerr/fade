const { sql } = require("@vercel/postgres");
const { sendJson, methodNotAllowed } = require("../_utils");
const { getBearerToken, getProfileByToken } = require("../_auth");

module.exports = async (req, res) => {
  if (req.method !== "POST") {
    return methodNotAllowed(res);
  }

  const token = getBearerToken(req);
  const profile = await getProfileByToken(token);

  if (!profile) {
    return sendJson(res, 401, { error: "unauthorized" });
  }

  const { rows } = await sql`
    update profiles
    set start_at = coalesce(start_at, now())
    where id = ${profile.id}
    returning start_at
  `;

  const startAt = rows[0]?.start_at;
  return sendJson(res, 200, {
    startAt: startAt ? new Date(startAt).toISOString() : null,
  });
};
