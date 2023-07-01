let symbol;
let stock_labels = ["initial"];
let stock_data = [10000];
let change = 0;
var chart;
// const params = new URLSearchParams(window.location.search);
// console.log(params);
import { Faker } from "@faker-js/faker";

async function getOneDayChart() {
  return new Promise(async function (resolve) {
    try {
      stock_labels = ["1", "2", "3", "4", "5"];
      stock_data = [1, 2, 3, 4, 5];
      change = 1;
      resolve();
    } catch (err) {
      resolve();
    }
  });
}

let loading = false;

import React, { useEffect, useRef } from "react";
import { formatCurrency, getUserAllTransactions } from "@/helpers";

function updateChart() {
  chart?.update();
}

//import Chart from "../../../node_modules/chart.js/dist/Chart.js";
import Script from "next/script.js";
import { useSupabaseClient, useUser } from "@supabase/auth-helpers-react";

function PortChart() {
  const supabase = useSupabaseClient();
  const user = useUser();

  async function getData() {
    try {
      const transactions = await getUserAllTransactions(supabase, user.id);
      console.log(transactions);
      let balance = 10000;
      stock_labels = transactions.map((transaction) => transaction.coinUUID);
      stock_data = transactions.map((transaction) => {
        balance = transaction.buyID
          ? balance + transaction.coinPrice * transaction.quantity
          : balance - transaction.coinPrice * transaction.quantity;
        return balance;
      });
      stock_data.unshift(10000);
      stock_labels.unshift("initial");
    } catch (err) {
      stock_data = [];
      stock_labels = [];
      console.log(err);
    }
  }
  useEffect(() => {
    // console.log(isUp);
    //background-image: linear-gradient(to right, #43e97b 0%, #38f9d7 100%);
    var ctx = document.getElementById("stock_chart").getContext("2d");
    const gradient = ctx.createLinearGradient(0, 0, 600, 10);
    // gradient.addColorStop(0, "#7c83ff");
    // gradient.addColorStop(1, "#7cf4ff");

    let gradientFill = ctx.createLinearGradient(0, 0, 0, 100);
    gradientFill.addColorStop(0, "rgba(124, 131, 255,.3)");
    gradientFill.addColorStop(0.2, "rgba(124, 244, 255,.15)");
    gradientFill.addColorStop(1, "rgba(255, 255, 255, 0)");
    ctx.shadowBlur = 5;
    ctx.shadowOffsetX = 0;
    ctx.shadowOffsetY = 4;
    function drawchart(ctx, gradient, gradientFill) {
      if (chart != null) {
        chart.destroy();
      }
      try {
        chart = new Chart(ctx, {
          type: "line",
          data: {
            labels: stock_labels,
            datasets: [
              {
                lineTension: 0.1,
                label: "",
                pointBorderWidth: 0,
                pointHoverRadius: 0,
                borderColor: gradient,
                backgroundColor: gradientFill,
                pointBackgroundColor: gradient,
                fill: true,
                borderWidth: 2,
                data: stock_data,
              },
            ],
          },
          options: {
            layout: {
              padding: {
                right: 25,
                left: 0, //left paddin of chart
              },
            },
            tooltips: {
              mode: "index",
              intersect: false,
              callbacks: {
                label(tooltipItems, data) {
                  return `${formatCurrency(tooltipItems.yLabel)}`;
                },
              },
              displayColors: false,
            },
            hover: {
              mode: "index",
              intersect: false,
            },
            maintainAspectRatio: false,
            responsive: true,
            legend: {
              display: false,
            },
            scales: {
              xAxes: [
                {
                  display: false,
                },
              ],
              fontStyle: "bold",
              yAxes: [
                {
                  gridLines: {
                    color: "rgba(0, 0, 0, 0)",
                  },
                  fontStyle: "bold",

                  ticks: {
                    callback(value) {
                      return formatCurrency(
                        value,
                        value > 100000 ? "compact" : "standard"
                      );
                    },
                    autoSkipPadding: 5,
                  },
                },
              ],
            },
            elements: {
              point: {
                radius: 0,
              },
              line: {
                borderCapStyle: "round",
                borderJoinStyle: "round",
              },
            },
          },
        });
      } catch (e) {
        console.log(e);
        // setTimeout(() => {
        //   drawchart(ctx, gradient, gradientFill);
        // }, 1000);
      }
    }

    symbol = "Qwsogvtv82FCd";
    getData().then(function () {
      const start = stock_data[0];
      const end = stock_data[stock_data.length - 1];
      gradient.addColorStop(0, start > end > 0 ? "#38f9d7" : "#e74c3c");
      gradient.addColorStop(1, start < end > 0 ? "#43e97b" : "#e74c3c");
      drawchart(ctx, gradient, gradientFill);
    });
  }, [user]);
  return (
    <>
      <Script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></Script>
      {/* <div className="chartjs-size-monitor-expand">
        <div className=""></div>
      </div>
      <div className="chartjs-size-monitor-shrink">
        <div className=""></div>
      </div> */}
      <div
        // className="chart-container"
        style={{ position: "relative", height: "20vh", width: "35vw" }}>
        <canvas
          id="stock_chart"
          style={{ width: "30vw", height: "20vh" }}
          className="chartjs-render-monitor"></canvas>
      </div>

      {/* <div className="Chart__timers"></div> */}
    </>
  );
}

export default PortChart;
