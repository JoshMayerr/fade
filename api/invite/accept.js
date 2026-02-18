const { sql } = require("@vercel/postgres");
const { readJson, sendJson, methodNotAllowed } = require("../_utils");
const { getBearerToken, getProfileByToken } = require("../_auth");

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

  const inviteCode = typeof body?.inviteCode === "string" ? body.inviteCode.trim() : "";
  if (!inviteCode) {
    return sendJson(res, 400, { error: "missing_invite_code" });
  }

  const token = getBearerToken(req);
  const profile = await getProfileByToken(token);
  if (!profile) {
    return sendJson(res, 401, { error: "unauthorized" });
  }

  const { rows } = await sql`
    select code, inviter_profile_id, expires_at, used_by
    from invites
    where code = ${inviteCode}
    limit 1
  `;
  const invite = rows[0];

  if (!invite) {
    return sendJson(res, 404, { error: "invite_not_found" });
  }

  if (invite.inviter_profile_id === profile.id) {
    return sendJson(res, 409, { error: "self_invite" });
  }

  if (invite.expires_at && new Date(invite.expires_at).getTime() < Date.now()) {
    return sendJson(res, 410, { error: "invite_expired" });
  }

  if (invite.used_by && invite.used_by !== profile.id) {
    return sendJson(res, 409, { error: "invite_used" });
  }

  if (!invite.used_by) {
    await sql`
      update invites
      set used_by = ${profile.id}, used_at = now()
      where code = ${inviteCode}
    `;
  }

  await sql`
    insert into friends (user_id, friend_id)
    values (${profile.id}, ${invite.inviter_profile_id})
    on conflict do nothing
  `;

  await sql`
    insert into friends (user_id, friend_id)
    values (${invite.inviter_profile_id}, ${profile.id})
    on conflict do nothing
  `;

  return sendJson(res, 200, { ok: true });
};
