let symbol;
let stock_labels = [];
let stock_data = [];
let change = 0;
var chart;
// const params = new URLSearchParams(window.location.search);
// console.log(params);

async function getOneDayChart() {
  return new Promise(async function (resolve) {
    var response = await fetch(`/api/getOneDayData?uuid=${symbol}`);
    var res_data = await response.json();
    try {
      stock_labels = res_data.chart["labels"];
      stock_data = res_data.chart["data"];
      change = res_data.change;
      resolve();
    } catch (err) {
      resolve();
    }
  });
}

async function getOneYearChart() {
  return new Promise(async function (resolve) {
    var response = await fetch(`/api/getOneYearData?uuid=${symbol}`);
    var res_data = await response.json();
    stock_labels = res_data.chart["labels"];
    stock_data = res_data.chart["data"];
    change = res_data.change;
    // console.log(data["labels"]);
    chart.data.labels = stock_labels;
    chart.data.datasets.data = stock_data;
    resolve();
  });
}

async function getOneMonthChart() {
  return new Promise(async function (resolve) {
    var response = await fetch(`/api/getOneMonthData?uuid=${symbol}`);
    var res_data = await response.json();
    stock_labels = res_data.chart["labels"];
    stock_data = res_data.chart["data"];
    change = res_data.change;
    // console.log(data["labels"]);
    chart.data.labels = stock_labels;
    chart.data.datasets.data = stock_data;
    resolve();
  });
}

function YearChart() {
  getOneYearChart().then(() => {
    chart.update();
    chart.destroy();
    drawchart();
  });
}

function MonthChart() {
  getOneMonthChart().then(() => {
    chart.update();
    chart.destroy();
    drawchart();
  });
}

function DayChart() {
  getOneDayChart().then(() => {
    chart.update();
    chart.destroy();
    drawchart();
  });
}

let loading = false;

import React, { useEffect, useRef } from "react";
import { formatCurrency } from "@/helpers";

function updateChart() {
  chart?.update();
}

//import Chart from "../../../node_modules/chart.js/dist/Chart.js";
import Script from "next/script.js";

function FChart() {
  const year = useRef();
  const month = useRef();
  const day = useRef();
  function changeFocus(option) {
    let btn = document.getElementById(`${option}`);
    console.log(btn);
    setTimeout(function () {
      var elems = document.querySelectorAll(".Chart__option");

      [].forEach.call(elems, function (el) {
        el.classList.remove("active");
      });
      btn.classList.add("active");
    }, 200);
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

    symbol = window.location.href.split("/").pop();
    getOneDayChart().then(function () {
      const start = stock_data[0];
      const end = stock_data[stock_data.length - 1];
      gradient.addColorStop(0, start > end > 0 ? "#38f9d7" : "#e74c3c");
      gradient.addColorStop(1, start < end > 0 ? "#43e97b" : "#e74c3c");
      drawchart(ctx, gradient, gradientFill);
    });
    const yearBtn = document.getElementById("3");
    const monthBtn = document.getElementById("2");
    const dayBtn = document.getElementById("1");
    yearBtn.addEventListener("click", () => {
      if (loading) return;
      loading = true;
      getOneYearChart().then(function () {
        const start = stock_data[0];
        const end = stock_data[stock_data.length - 1];
        const gradient2 = ctx.createLinearGradient(0, 0, 600, 10);
        gradient2.addColorStop(0, start > end > 0 ? "#38f9d7" : "#e74c3c");
        gradient2.addColorStop(1, start < end > 0 ? "#43e97b" : "#e74c3c");
        drawchart(ctx, gradient2, gradientFill);
        loading = false;
      });
      changeFocus(3);
    });
    monthBtn.addEventListener("click", () => {
      if (loading) return;
      loading = true;
      getOneMonthChart().then(function () {
        const start = stock_data[0];
        const end = stock_data[stock_data.length - 1];
        const gradient2 = ctx.createLinearGradient(0, 0, 600, 10);
        gradient2.addColorStop(0, start > end > 0 ? "#38f9d7" : "#e74c3c");
        gradient2.addColorStop(1, start < end > 0 ? "#43e97b" : "#e74c3c");
        // gradient2.addColorStop(0, start > end > 0 ? "#38f9d7" : "#000000");
        // gradient2.addColorStop(1, change > 0 ? "#43e97b" : "#e74c3c");
        drawchart(ctx, gradient2, gradientFill);
        loading = false;
      });
      changeFocus(2);
    });
    dayBtn.addEventListener("click", () => {
      if (loading) return;
      loading = true;
      getOneDayChart().then(function () {
        const start = stock_data[0];
        const end = stock_data[stock_data.length - 1];
        const gradient2 = ctx.createLinearGradient(0, 0, 600, 10);
        gradient2.addColorStop(0, start > end > 0 ? "#38f9d7" : "#e74c3c");
        gradient2.addColorStop(1, start < end > 0 ? "#43e97b" : "#e74c3c");
        drawchart(ctx, gradient2, gradientFill);
        loading = false;
      });
      changeFocus(1);
    });
  }, []);
  return (
    <div className="Chart">
      <Script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></Script>
      <div className="chartjs-size-monitor-expand">
        <div className=""></div>
      </div>
      <div className="chartjs-size-monitor-shrink">
        <div className=""></div>
      </div>
      <canvas id="stock_chart" className="chartjs-render-monitor"></canvas>
      <div className="Chart__timers">
        <h6 className="Chart__option" ref={year} id="3">
          1Y
        </h6>
        <h6
          className="Chart__option"
          ref={month}
          id="2"
          onClick={() => {
            changeFocus(2);
            getOneMonthChart();
          }}>
          1M
        </h6>
        <h6
          className="Chart__option active"
          ref={day}
          id="1"
          onClick={() => {
            changeFocus(1);
            getOneDayChart();
          }}>
          1D
        </h6>
      </div>
    </div>
  );
}

export default FChart;
