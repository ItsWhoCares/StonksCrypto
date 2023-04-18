import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { useSession, useSupabaseClient } from "@supabase/auth-helpers-react";
import Topbar from "@/components/Elements/topbar";
import Buy from "@/components/Elements/buy";
import KeyInfo from "@/components/KeyInfo/KeyInfo";
import FChart from "@/components/Chart/FChart";
import Link from "next/link";
import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";

export default function Coin() {
  const router = useRouter();
  const coinUuid = router.query.uuid;
  // const session = useSession();
  // const supabase = useSupabaseClient();
  const [coinInfo, setCoinInfo] = useState();
  const getCoinInfo = async () => {
    const res = await fetch(`/api/getCoinInfo?uuid=${router.query.uuid}`);
    const data = await res.json();
    return data;
  };
  // useEffect(() => {
  //   const interval = setInterval(async () => {
  //     const coin = await getCoinInfo();
  //     if (!coin.error) {
  //       console.log(coin);
  //       setCoinInfo(coin);
  //       clearInterval(interval);
  //     }
  //   }, 5000);
  //   return () => clearInterval(interval);
  // }, [getCoinInfo]);
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
              <Leftbar />
              <div class="stockPage">
                <LeftbarMobile />
                <Topbar />
                <div class="stockPage__top">
                  <FChart />

                  <Buy />
                </div>
                <KeyInfo />
              </div>
            </div>
          </section>
        </div>
      </main>
    </>
  );
}
