const exec = require("child_process").exec;

const sed = () => {
  try {
    exec(
      "sed -e 's/: /=\"/;s/$/\"/g' containers/api/.env-temp > containers/api/.env && rm containers/api/.env-temp"
    );
  } catch (e) {
    console.log(e);
  }
};

module.exports = sed();
