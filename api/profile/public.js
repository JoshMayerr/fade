const { sql } = require("../_db");
const { sendJson, methodNotAllowed, getUrl } = require("../_utils");

module.exports = async (req, res) => {
  if (req.method !== "GET") {
    return methodNotAllowed(res);
  }

  const url = getUrl(req);
  const shareId = url.searchParams.get("shareId");

  if (!shareId) {
    return sendJson(res, 400, { error: "missing_share_id" });
  }

  const { rows } = await sql`
    select share_id, display_name, start_at
    from profiles
    where share_id = ${shareId}
    limit 1
  `;

  const profile = rows[0];
  if (!profile) {
    return sendJson(res, 404, { error: "not_found" });
  }

  return sendJson(res, 200, {
    shareId: profile.share_id,
    displayName: profile.display_name,
    startAt: profile.start_at ? new Date(profile.start_at).toISOString() : null,
  });
};
