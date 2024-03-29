// export default async function getCoinInfo(req, res) {
//   const data = await fetch(
//     `https://api.coinranking.com/v2/coin/${req.query.uuid}`
//   );
//   const coin = await data.json();
//   //   console.log(coin);
//   if (coin.status === "fail") {
//     res.status(404).json({ error: "Coin not found" });
//   } else res.status(200).json(coin.data.coin);
// }

// const options = {
//   method: "GET",
//   headers: {
//     "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
//     "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
//   },
// };
import { getRandomCoinKey } from "@/helpers";

export default async function getCoinInfo(req, res) {
  let key = getRandomCoinKey();
  // console.log(key);
  res.setHeader("Cache-Control", "s-maxage=86400");
  const options = {
    headers: {
      "Content-Type": "application/json",
      "x-access-token": key,
    },
  };
  const data = await fetch(
    `https://api.coinranking.com/v2/coin/${req.query.uuid}?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}`,
    options
  );
  const coin = await data.json();
  //   console.log(coin);
  if (coin.status === "fail") {
    res.status(404).json({
      error: true,
      errorMsg: coin.message,
    });
  } else res.status(200).json(coin?.data?.coin ?? { error: true });
}
