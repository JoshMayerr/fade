const { sql } = require("../_db");
const { sendJson, methodNotAllowed } = require("../_utils");
const { getBearerToken, getProfileByToken } = require("../_auth");
const { randomString } = require("../_tokens");

const MAX_ATTEMPTS = 5;

module.exports = async (req, res) => {
  if (req.method !== "POST") {
    return methodNotAllowed(res);
  }

  const token = getBearerToken(req);
  const profile = await getProfileByToken(token);

  if (!profile) {
    return sendJson(res, 401, { error: "unauthorized" });
  }

  let inviteCode = null;
  let inviteUrl = null;

  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt += 1) {
    const code = randomString(8);
    try {
      const rows = await sql`
        insert into invites (code, inviter_profile_id, expires_at)
        values (${code}, ${profile.id}, now() + interval '7 days')
        returning code
      `;
      inviteCode = rows[0].code;
      inviteUrl = `https://fade.cool/i/${inviteCode}`;
      break;
    } catch (error) {
      if (!`${error}`.includes("unique")) {
        throw error;
      }
    }
  }

  if (!inviteCode) {
    return sendJson(res, 500, { error: "could_not_create_invite" });
  }

  return sendJson(res, 200, { inviteCode, inviteUrl });
};
