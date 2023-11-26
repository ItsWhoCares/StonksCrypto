// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

const options = {
  method: "GET",
  headers: {
    "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
    "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
  },
};

export default async function handler(req, res) {
  //res.status(200).send(testdata);
  const data = await fetch(
    `https://coinranking1.p.rapidapi.com/coins?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}&timePeriod=24h&tiers%5B0%5D=1&orderBy=marketCap&orderDirection=desc&limit=10&offset=0`,
    options
  );
  const json = await data.json();
  if (json.status == "fail") {
    res.status(200).send({ error: true });
  } else {
    res.status(200).send(json.data.coins);
  }
}
