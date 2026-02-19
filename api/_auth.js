const { sql } = require("./_db");

const getBearerToken = (req) => {
  const header = req.headers.authorization || "";
  if (!header.startsWith("Bearer ")) {
    return null;
  }
  return header.slice("Bearer ".length).trim();
};

const getProfileByToken = async (token) => {
  if (!token) {
    return null;
  }
  const rows = await sql`
    select id, share_id, write_token, display_name, start_at
    from profiles
    where write_token = ${token}
    limit 1
  `;
  return rows[0] || null;
};

module.exports = {
  getBearerToken,
  getProfileByToken,
};
