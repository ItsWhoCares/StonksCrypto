import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { useSession, useSupabaseClient } from "@supabase/auth-helpers-react";
import Topbar from "@/components/Elements/topbar";
import Buy from "@/components/Elements/buy";
import KeyInfo from "@/components/KeyInfo/KeyInfo";
import FChart from "@/components/Chart/FChart";

export default function Coin() {
  const router = useRouter();
  const session = useSession();
  const supabase = useSupabaseClient();
  const [coinInfo, setCoinInfo] = useState();
  // const getCoinInfo = async () => {
  //   const res = await fetch(`/api/getCoinInfo?uuid=${router.query.uuid}`);
  //   const data = await res.json();
  //   return data;
  // };
  // useEffect(() => {
  //   console.log("hehe");
  //   const interval = setInterval(async () => {
  //     const coin = await getCoinInfo();
  //     if (!coin.error) {
  //       console.log(coin);
  //       setCoinInfo(coin);
  //       clearInterval(interval);
  //     }
  //   }, 5000);
  //   return () => clearInterval(interval);
  // }, []);
  // const coinUuid = router.query.uuid;
  // useEffect(() => {
  //   fetch(`/api/getCoinInfo?uuid=${coinUuid}`)
  //     .then((res) => res.json())
  //     .then((data) => {
  //       setCoinInfo(data);
  //       console.log(data);
  //     });
  // }, []);
  // useEffect(() => {
  //   if (!session) {
  //     router.push("/");
  //   }
  // }, [session]);
  // const labels = ["1", "2", "3"];
  // const chartData1 = [1, 2, 3];
  // const data1 = (canvas) => {
  //   const ctx = canvas.getContext("2d");
  //   const gradient = ctx.createLinearGradient(0, 0, 600, 10);
  //   gradient.addColorStop(0, "#7c83ff");
  //   gradient.addColorStop(1, "#7cf4ff");
  //   let gradientFill = ctx.createLinearGradient(0, 0, 0, 100);
  //   gradientFill.addColorStop(0, "rgba(124, 131, 255,.3)");
  //   gradientFill.addColorStop(0.2, "rgba(124, 244, 255,.15)");
  //   gradientFill.addColorStop(1, "rgba(255, 255, 255, 0)");
  //   ctx.shadowBlur = 5;
  //   ctx.shadowOffsetX = 0;
  //   ctx.shadowOffsetY = 4;
  //   return {
  //     labels,
  //     datasets: [
  //       {
  //         lineTension: 0.1,
  //         label: "",
  //         pointBorderWidth: 0,
  //         pointHoverRadius: 0,
  //         borderColor: gradient,
  //         backgroundColor: gradientFill,
  //         pointBackgroundColor: gradient,
  //         fill: true,
  //         borderWidth: 2,
  //         data: chartData1,
  //       },
  //     ],
  //   };
  // };

  // const changeFocus = (option) => {
  //   setTimeout(
  //     function () {
  //       var elems = document.querySelectorAll(".Chart__option");

  //       [].forEach.call(elems, function (el) {
  //         el.classList.remove("active");
  //       });
  //       switch (option) {
  //         case 1:
  //           this.day.current.classList.add("active");
  //           break;

  //         case 2:
  //           this.month.current.classList.add("active");
  //           break;

  //         case 3:
  //           this.year.current.classList.add("active");
  //           break;

  //         case 4:
  //           this.years.current.classList.add("active");
  //           break;

  //         case 5:
  //           this.ytd.current.classList.add("active");
  //           break;

  //         default:
  //           this.ytd.current.classList.add("active");
  //           break;
  //       }
  //     }.bind(this),
  //     200
  //   );
  // };

  return (
    <>
      <main id="root">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>
        <div class="container">
          <section class="stock">
            <div
              class="black-bg"
              id="blackbg"
              style={{ display: "none" }}></div>
            <div
              class="buyConfirmation"
              id="confirmbox"
              style={{ display: "none" }}>
              {/* <!--<h3>
              Are you sure you want to buy 10 shares of VKTX for
              <span style={{"fontWeight":"bold"}}>128.8</span> dollars
            </h3> --> */}
              <div>
                <button class="stockPage__buy-button">CONFIRM</button>
                <button class="stockPage__buy-button cancel">CANCEL</button>
              </div>
            </div>

            <div style={{ display: "flex", height: "100%" }}>
              <aside class="leftbar">
                <svg
                  class="leftbar__logo"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24">
                  <g>
                    <path fill="none" d="M0 0h24v24H0z"></path>
                    <path d="M3.897 17.86l3.91-3.91 2.829 2.828 4.571-4.57L17 14V9h-5l1.793 1.793-3.157 3.157-2.828-2.829-4.946 4.946A9.965 9.965 0 0 1 2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10a9.987 9.987 0 0 1-8.103-4.14z"></path>
                  </g>
                </svg>
                <ul class="leftbar__menu">
                  <a href="/dashboard">
                    <li>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="48"
                        height="48"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#dddddd"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        style={{ stroke: "rgb(221, 221, 221)" }}>
                        <path d="M20 9v11a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V9"></path>
                        <path d="M9 22V12h6v10M2 10.6L12 2l10 8.6"></path>
                      </svg>
                    </li>
                  </a>

                  <a href="/trends/topGainers">
                    <li>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="48"
                        height="48"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#dddddd"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        style={{ stroke: "rgb(221, 221, 221)" }}>
                        <path d="M12 20v-6M6 20V10M18 20V4"></path>
                      </svg>
                    </li>
                  </a>

                  <a href="/portfolio">
                    <li>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="48"
                        height="48"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#dddddd"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        style={{ stroke: "rgb(221, 221, 221)" }}>
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                      </svg>
                    </li>
                  </a>
                  <a href="/watchlist">
                    <li>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="48"
                        height="48"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#dddddd"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        style={{ stroke: "rgb(221, 221, 221)" }}>
                        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                      </svg>
                    </li>
                  </a>
                </ul>

                <h5
                  class="panel__status"
                  id="panel__status"
                  style={{ color: "rgb(94, 250, 215)" }}>
                  Market status: Open
                </h5>

                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="leftbar__log"
                  viewBox="0 0 24 24"
                  id="logout">
                  <g>
                    <path fill="none" d="M0 0h24v24H0z"></path>
                    <path d="M4 18h2v2h12V4H6v2H4V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3zm2-7h7v2H6v3l-5-4 5-4v3z"></path>
                  </g>
                </svg>
              </aside>
              <div class="stockPage">
                <nav style={{ display: "flex", alignItems: "center" }}>
                  <div class="mobileMenu" id="mobileMenu">
                    <aside class="leftbar">
                      <svg
                        class="leftbar__logo"
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24">
                        <g>
                          <path fill="none" d="M0 0h24v24H0z"></path>
                          <path d="M3.897 17.86l3.91-3.91 2.829 2.828 4.571-4.57L17 14V9h-5l1.793 1.793-3.157 3.157-2.828-2.829-4.946 4.946A9.965 9.965 0 0 1 2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10a9.987 9.987 0 0 1-8.103-4.14z"></path>
                        </g>
                      </svg>
                      <ul class="leftbar__menu">
                        <a href="/dashboard">
                          <li>
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              width="48"
                              height="48"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="#dddddd"
                              stroke-width="2"
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              style={{ stroke: "rgb(221, 221, 221)" }}>
                              <path d="M20 9v11a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V9"></path>
                              <path d="M9 22V12h6v10M2 10.6L12 2l10 8.6"></path>
                            </svg>
                          </li>
                        </a>
                        <a href="/portfolio">
                          <li>
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              width="48"
                              height="48"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="#dddddd"
                              stroke-width="2"
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              style={{ stroke: "rgb(221, 221, 221)" }}>
                              <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                              <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                            </svg>
                          </li>
                        </a>
                        <a href="/watchlist">
                          <li>
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              width="48"
                              height="48"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="#dddddd"
                              stroke-width="2"
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              style={{ stroke: "rgb(221, 221, 221)" }}>
                              <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                            </svg>
                          </li>
                        </a>
                      </ul>

                      <h5
                        class="panel__status"
                        id="panel__status"
                        style={{ color: "rgb(94, 250, 215)" }}>
                        Market status: Open
                      </h5>

                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="leftbar__log"
                        viewBox="0 0 24 24">
                        <g>
                          <path fill="none" d="M0 0h24v24H0z"></path>
                          <path d="M4 18h2v2h12V4H6v2H4V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3zm2-7h7v2H6v3l-5-4 5-4v3z"></path>
                        </g>
                      </svg>
                    </aside>
                  </div>
                </nav>
                <Topbar />
                <div class="stockPage__top">
                  <FChart />

                  <Buy />
                </div>
                <KeyInfo CoinInfo={coinInfo} />
              </div>
            </div>
          </section>
        </div>
      </main>
    </>
  );
}
