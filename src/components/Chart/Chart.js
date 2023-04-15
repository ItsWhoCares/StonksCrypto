// // import React from "react";
// // import { Line } from "react-chartjs-2";
// // import PropTypes from "prop-types";

// // var options = {
// //   layout: {
// //     padding: {
// //       right: 25,
// //       left: 25,
// //     },
// //   },
// //   tooltips: {
// //     mode: "index",
// //     intersect: false,
// //     callbacks: {
// //       label(tooltipItems, data) {
// //         return `$${tooltipItems.yLabel}`;
// //       },
// //     },
// //     displayColors: false,
// //   },
// //   hover: {
// //     mode: "index",
// //     intersect: false,
// //   },
// //   maintainAspectRatio: false,
// //   responsive: true,
// //   legend: {
// //     display: false,
// //   },
// //   scales: {
// //     xAxes: [
// //       {
// //         display: false,
// //       },
// //     ],
// //     fontStyle: "bold",
// //     yAxes: [
// //       {
// //         gridLines: {
// //           color: "rgba(0, 0, 0, 0)",
// //         },
// //         fontStyle: "bold",

// //         ticks: {
// //           callback(value) {
// //             return "$" + value.toFixed(2);
// //           },
// //         },
// //       },
// //     ],
// //   },
// //   elements: {
// //     point: {
// //       radius: 0,
// //     },
// //     line: {
// //       borderCapStyle: "round",
// //       borderJoinStyle: "round",
// //     },
// //   },
// // };

// // const FullChart = ({
// //   month,
// //   day,
// //   year,
// //   data1,
// //   changeFocus,
// //   getOneYearChart,
// //   getOneMonthChart,
// //   getOneDayChart,
// // }) => (
// //   <div className="Chart">
// //     <Line data={data1} options={options} />
// //     <div className="Chart__timers">
// //       <h6
// //         className="Chart__option"
// //         ref={year}
// //         id="1y"
// //         onClick={() => {
// //           getOneYearChart();
// //           changeFocus(3);
// //         }}>
// //         1Y
// //       </h6>
// //       <h6
// //         className="Chart__option"
// //         ref={month}
// //         id="1m"
// //         onClick={() => {
// //           changeFocus(2);
// //           getOneMonthChart();
// //         }}>
// //         1M
// //       </h6>
// //       <h6
// //         className="Chart__option"
// //         ref={day}
// //         id="1d"
// //         onClick={() => {
// //           changeFocus(1);
// //           getOneDayChart();
// //         }}>
// //         1D
// //       </h6>
// //     </div>
// //   </div>
// // );

// // FullChart.propTypes = {
// //   changeFocus: PropTypes.func,
// //   getOneMonthChart: PropTypes.func,
// //   getOneYearChart: PropTypes.func,
// //   getOneDayChart: PropTypes.func,
// //   data1: PropTypes.func,
// //   year: PropTypes.object,
// //   years: PropTypes.object,
// //   stockData: PropTypes.object,
// //   ytd: PropTypes.object,
// //   month: PropTypes.object,
// //   day: PropTypes.object,
// // };

// let symbol;
// let stock_labels = [];
// let stock_data = [];
// var chart;
// // const params = new URLSearchParams(window.location.search);
// // console.log(params);

// async function getOneDayChart() {
//   return new Promise(async function (resolve) {
//     var response = await fetch(`/api/getOneDayData?uuid=${symbol}`);
//     var res_data = await response.json();
//     stock_labels = res_data["labels"];
//     stock_data = res_data["data"];
//     resolve();
//   });
// }

// async function getOneYearChart() {
//   return new Promise(async function (resolve) {
//     var response = await fetch(`/api/getOneYearData?uuid=${symbol}`);
//     var res_data = await response.json();
//     stock_labels = res_data["labels"];
//     stock_data = res_data["data"];
//     // console.log(data["labels"]);
//     chart.data.labels = stock_labels;
//     chart.data.datasets.data = stock_data;
//     resolve();
//   });
// }

// async function getOneMonthChart() {
//   return new Promise(async function (resolve) {
//     var response = await fetch(`/OneMonthChart/${symbol}`);
//     var res_data = await response.json();
//     stock_labels = res_data["labels"];
//     stock_data = res_data["data"];
//     // console.log(data["labels"]);
//     chart.data.labels = stock_labels;
//     chart.data.datasets.data = stock_data;
//     resolve();
//   });
// }

// function YearChart() {
//   getOneYearChart().then(() => {
//     chart.update();
//     chart.destroy();
//     drawchart();
//   });
// }

// function MonthChart() {
//   getOneMonthChart().then(() => {
//     chart.update();
//     chart.destroy();
//     drawchart();
//   });
// }

// function DayChart() {
//   getOneDayChart().then(() => {
//     chart.update();
//     chart.destroy();
//     drawchart();
//   });
// }

// // function redraw() {
// //   chart.destroy();
// //   drawchart();
// // }
// // window.addEventListener("resize", redraw);
// function drawchart(ctx, gradient, gradientFill) {
//   chart = new Chart(ctx, {
//     type: "line",
//     data: {
//       labels: stock_labels,
//       datasets: [
//         {
//           lineTension: 0.1,
//           label: "",
//           pointBorderWidth: 0,
//           pointHoverRadius: 0,
//           borderColor: gradient,
//           backgroundColor: gradientFill,
//           pointBackgroundColor: gradient,
//           fill: true,
//           borderWidth: 2,
//           data: stock_data,
//         },
//       ],
//     },
//     options: {
//       layout: {
//         padding: {
//           right: 25,
//           left: 0, //left paddin of chart
//         },
//       },
//       tooltips: {
//         mode: "index",
//         intersect: false,
//         callbacks: {
//           label(tooltipItems, data) {
//             return `${formatCurrency(tooltipItems.yLabel)}`;
//           },
//         },
//         displayColors: false,
//       },
//       hover: {
//         mode: "index",
//         intersect: false,
//       },
//       maintainAspectRatio: false,
//       responsive: true,
//       legend: {
//         display: false,
//       },
//       scales: {
//         xAxes: [
//           {
//             display: false,
//           },
//         ],
//         fontStyle: "bold",
//         yAxes: [
//           {
//             gridLines: {
//               color: "rgba(0, 0, 0, 0)",
//             },
//             fontStyle: "bold",

//             ticks: {
//               callback(value) {
//                 return formatCurrency(value);
//               },
//               autoSkipPadding: 5,
//             },
//           },
//         ],
//       },
//       elements: {
//         point: {
//           radius: 0,
//         },
//         line: {
//           borderCapStyle: "round",
//           borderJoinStyle: "round",
//         },
//       },
//     },
//   });
// }

// import React, { useEffect, useRef } from "react";
// import { formatCurrency } from "@/helpers";

// function FullChart() {
//   const year = useRef();
//   const month = useRef();
//   const day = useRef();
//   function changeFocus(option) {
//     let btn = document.getElementById(`${option}`);
//     console.log(btn);
//     setTimeout(function () {
//       var elems = document.querySelectorAll(".Chart__option");

//       [].forEach.call(elems, function (el) {
//         el.classList.remove("active");
//       });
//       btn.classList.add("active");
//     }, 200);
//   }
//   useEffect(() => {
//     var ctx = document.getElementById("stock_chart").getContext("2d");
//     const gradient = ctx.createLinearGradient(0, 0, 600, 10);
//     gradient.addColorStop(0, "#7c83ff");
//     gradient.addColorStop(1, "#7cf4ff");
//     let gradientFill = ctx.createLinearGradient(0, 0, 0, 100);
//     gradientFill.addColorStop(0, "rgba(124, 131, 255,.3)");
//     gradientFill.addColorStop(0.2, "rgba(124, 244, 255,.15)");
//     gradientFill.addColorStop(1, "rgba(255, 255, 255, 0)");
//     ctx.shadowBlur = 5;
//     ctx.shadowOffsetX = 0;
//     ctx.shadowOffsetY = 4;

//     symbol = window.location.href.split("/").pop();
//     getOneDayChart().then(function () {
//       console.log("drawing chart\n\n\n\n");
//       drawchart(ctx, gradient, gradientFill);
//     });
//     function redraw() {
//       chart?.destroy();
//       drawchart(ctx, gradient, gradientFill);
//     }
//     window.addEventListener("resize", redraw);
//     const yearBtn = document.getElementById("3");
//     const monthBtn = document.getElementById("2");
//     const dayBtn = document.getElementById("1");
//     yearBtn.addEventListener("click", () => {
//       getOneYearChart().then(function () {
//         console.log("drawing chart\n\n\n\n");
//         chart.destroy();
//         drawchart(ctx, gradient, gradientFill);
//         chart.update();
//       });
//       changeFocus(3);
//     });
//   }, []);
//   return (
//     <div className="Chart">
//       <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>
//       <div class="chartjs-size-monitor-expand">
//         <div class=""></div>
//       </div>
//       <div class="chartjs-size-monitor-shrink">
//         <div class=""></div>
//       </div>
//       <canvas id="stock_chart" class="chartjs-render-monitor"></canvas>
//       <div className="Chart__timers">
//         <h6 className="Chart__option" ref={year} id="3">
//           1Y
//         </h6>
//         <h6
//           className="Chart__option"
//           ref={month}
//           id="2"
//           onClick={() => {
//             changeFocus(2);
//             getOneMonthChart();
//           }}>
//           1M
//         </h6>
//         <h6
//           className="Chart__option"
//           ref={day}
//           id="1"
//           onClick={() => {
//             changeFocus(1);
//             getOneDayChart();
//           }}>
//           1D
//         </h6>
//       </div>
//     </div>
//   );
// }

// export default FullChart;
