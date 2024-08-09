import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";

dayjs.extend(utc);
dayjs.extend(timezone);

function formatToChart(data, timePeriod) {
  //format to lables and data
  let chartData = {
    labels: [],
    data: [],
  };
  //reverse the data
  data.reverse();

  if (timePeriod.includes("h")) {
    data.forEach((item) => {
      chartData.labels.push(
        dayjs.tz(item.timestamp * 1000, "Asia/Calcutta").format("ddd HH:mm")
      );
      chartData.data.push(item.price);
    });
  } else {
    data.forEach((item) => {
      chartData.labels.push(
        dayjs.tz(item.timestamp * 1000, "Asia/Calcutta").format("MMM YY")
      );
      chartData.data.push(item.price);
    });
  }

  return chartData;
}

const options = {
  method: "GET",
  headers: {
    "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
    "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
  },
};

export default async function oneHistoricalData(req, res) {
  const coinUuid = req.query.uuid;
  const timePeriod = req.query.timePeriod;
  const data = await fetch(
    `https://coinranking1.p.rapidapi.com/coin/${coinUuid}/history?referenceCurrencyUuid=${process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_UUID}&timePeriod=${timePeriod}`,
    options
  );

  const coin = await data.json();
  //   console.log(coin);
  if (coin.status === "fail") {
    res.status(404).json(coin);
  } else
    res.status(200).json({
      chart: formatToChart(coin.data.history, timePeriod),
      change: coin.data.change,
      timezone: dayjs.tz.guess(),
    });
}
