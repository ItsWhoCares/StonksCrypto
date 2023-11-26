// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

const options = {
  method: "GET",
  headers: {
    "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
    "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
  },
};

export default async function handler(req, res) {
  const coinUuid = req.query.uuid;
  const tp = req.query.tp;
  const data = await fetch(
    `https://coinranking1.p.rapidapi.com/coin/${coinUuid}/history?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}&timePeriod=${tp}`,
    options
  );

  const coin = await data.json();
  if (coin.status === "fail") {
    res.status(404).json(coin);
  } else {
    const change = coin.data.change;
    const history = coin.data.history.map((a) => ({
      value: parseFloat(a.price),
      timestamp: a.timestamp * 1000,
    }));
    history.reverse();
    res.status(200).send({ change, history });
  }
}
