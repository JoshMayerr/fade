const { sql } = require("./_db");
const { sendJson, methodNotAllowed } = require("./_utils");
const { getBearerToken, getProfileByToken } = require("./_auth");

module.exports = async (req, res) => {
  if (req.method !== "GET") {
    return methodNotAllowed(res);
  }

  const token = getBearerToken(req);
  const profile = await getProfileByToken(token);
  if (!profile) {
    return sendJson(res, 401, { error: "unauthorized" });
  }

  const { rows } = await sql`
    select p.share_id, p.display_name, p.start_at
    from friends f
    join profiles p on p.id = f.friend_id
    where f.user_id = ${profile.id}
    order by f.created_at desc
  `;

  const friends = rows.map((friend) => ({
    shareId: friend.share_id,
    displayName: friend.display_name,
    startAt: friend.start_at ? new Date(friend.start_at).toISOString() : null,
  }));

  return sendJson(res, 200, { friends });
};
