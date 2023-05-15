data = require("./coinlist");
console.log("[");
data.coins.map((coin) => {
  console.log("'" + coin.uuid + "'" + ",");
});
console.log("]");
