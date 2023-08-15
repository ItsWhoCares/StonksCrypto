import { getRandomCoinKey } from "@/helpers";
export default async function getCoinPrice(req, res) {
  const options = {
    headers: {
      "Content-Type": "application/json",
      "x-access-token": getRandomCoinKey(),
    },
  };
  const data = await fetch(
    `https://api.coinranking.com/v2/coin/${req.query.uuid}/price?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}`,
    options
  );

  const coin = await data.json();
  if (coin.status === "fail") {
    res.status(404).json({ error: true, errorMsg: "Coin not found" });
  } else res.status(200).json(coin.data);
}
