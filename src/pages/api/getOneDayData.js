import dayjs from "dayjs";
function formatToChart(data) {
  //format to lables and data
  let chartData = {
    labels: [],
    data: [],
  };
  //reverse the data
  data.reverse();

  data.forEach((item) => {
    chartData.labels.push(dayjs(item.timestamp * 1000).format("ddd HH:mm"));
    chartData.data.push(item.price);
  });

  return chartData;
}

const options = {
  method: "GET",
  headers: {
    "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
    "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
  },
};

export default async function oneDayData(req, res) {
  const coinUuid = req.query.uuid;
  const data = await fetch(
    `https://coinranking1.p.rapidapi.com/coin/${coinUuid}/history?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}&timePeriod=24h`,
    options
  );

  const coin = await data.json();
  //   console.log(coin);
  if (coin.status === "fail") {
    res.status(404).json(coin);
  } else res.status(200).json(formatToChart(coin.data.history));
}
