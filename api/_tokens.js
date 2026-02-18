const crypto = require("crypto");

const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

const randomString = (length) => {
  const bytes = crypto.randomBytes(length);
  let result = "";
  for (let i = 0; i < length; i += 1) {
    result += alphabet[bytes[i] % alphabet.length];
  }
  return result;
};

const randomToken = (length) => {
  return crypto.randomBytes(length).toString("hex");
};

module.exports = {
  randomString,
  randomToken,
};
