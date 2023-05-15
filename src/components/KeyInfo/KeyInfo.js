import { formatCurrency, formatNumber } from "@/helpers";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
export default function KeyInfo({ coin }) {
  const router = useRouter();
  //const coinUuid = router.query.uuid;
  const [coinInfo, setCoinInfo] = useState(coin);
  const getCoinInfo = async (coinUuid) => {
    // return { error: true };
    const data = await fetch(`/api/getCoinInfo?uuid=${coinUuid}`);
    const coin = await data.json();
    return coin;
  };
  // useEffect(() => {
  //   const coinUuid = window.location.pathname.split("/")[2];
  //   const interval = setInterval(async () => {
  //     const coin = await getCoinInfo(coinUuid);
  //     if (!coin.error) {
  //       setCoinInfo(coin);
  //       clearInterval(interval);
  //     }
  //   }, 5000);
  //   return () => clearInterval(interval);
  // }, []);
  //   return (
  //     <div className="stockPage__trade">
  //       <div className="stockPage__mobile">
  //         <div
  //           style={{
  //             display: "flex",
  //             flexDirection: "row",
  //             justifyContent: "flex-start",
  //             alignItems: "flex-start",
  //           }}>
  //           <img width={25} height={25} src={coinInfo?.iconUrl} alt="hehe" />
  //           <h4 style={{ padding: 5 }}>{coinInfo?.name}</h4>
  //           <svg
  //             id="bookmark"
  //             xmlns="http://www.w3.org/2000/svg"
  //             width="25"
  //             height="25"
  //             viewBox="0 0 24 24"
  //             fill="none"
  //             stroke-width="2"
  //             stroke-linecap="round"
  //             stroke-linejoin="round"
  //             stroke="#ddd"
  //             style={{ cursor: "pointer", marginLeft: "auto" }}>
  //             <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
  //           </svg>
  //         </div>
  //         <div className="stockPage__trade-top">
  //           <h2 id="latestprice">{formatCurrency(coinInfo?.price)}</h2>

  //           <h6
  //             style={{
  //               color:
  //                 coinInfo?.change > 0
  //                   ? "rgb(58, 232, 133)"
  //                   : "rgb(244, 83, 133)",
  //             }}>
  //             {coinInfo?.change}%
  //           </h6>
  //         </div>
  //       </div>
  //       {/* <!-- <h6> */}
  //       <div className="stockPage__trade-bottom">
  //         <div className="stockPage__trade-bottom-left">
  //           <div className="stockPage__trade-bottom-left-top">
  //             <h6>Market Cap</h6>
  //             <h6>{formatCurrency(coinInfo?.marketCap)}</h6>
  //           </div>
  //           <div className="stockPage__trade-bottom-left-bottom">
  //             <h6>Volume</h6>
  //             <h6>{formatCurrency(coinInfo?.volume)}</h6>
  //           </div>
  //         </div>
  //         <div className="stockPage__trade-bottom-right">
  //           <div className="stockPage__trade-bottom-right-top">
  //             <h6>High</h6>
  //             <h6>{formatCurrency(coinInfo?.high)}</h6>
  //           </div>
  //           <div className="stockPage__trade-bottom-right-bottom">
  //             <h6>Low</h6>
  //             <h6>{formatCurrency(coinInfo?.low)}</h6>
  //           </div>
  //         </div>
  //       </div>
  //     </div>
  //   );
  if (!coinInfo) {
    getCoinInfo(router.query.uuid).then((coin) => {
      if (!coin.error) {
        setCoinInfo(coin);
      }
    });
    return (
      <div className="stockPage__keyStats">
        <div className="Key-info">
          <h3>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <g>
                <path fill="none" d="M0 0h24v24H0z"></path>
                <path d="M12 22C6.477 22 2 17.523 2 12c0-4.478 2.943-8.268 7-9.542v2.124A8.003 8.003 0 0 0 12 20a8.003 8.003 0 0 0 7.418-5h2.124c-1.274 4.057-5.064 7-9.542 7zm9.95-9H11V2.05c.329-.033.663-.05 1-.05 5.523 0 10 4.477 10 10 0 .337-.017.671-.05 1zM13 4.062V11h6.938A8.004 8.004 0 0 0 13 4.062z"></path>
              </g>
            </svg>
            Key Informations
          </h3>
          <div className="Key-info__columns">
            <div className="Key-info__info">
              <h4 className="Key-info__label">Market Cap</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",

                    // border: "1px solid #222831",
                    // borderRadius: 10,
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
            <div className="Key-info__info">
              <h4 className="Key-info__label">Coin Rank</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
            <div className="Key-info__info">
              <h4 className="Key-info__label">All Time High</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
            <div className="Key-info__info">
              <h4 className="Key-info__label">24h volume</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
            <div className="Key-info__info">
              <h4 className="Key-info__label">Circulating supply</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
            <div className="Key-info__info">
              <h4 className="Key-info__label">Max supply</h4>
              <h3>
                <div
                  style={{
                    width: 100,
                    height: 25,

                    marginLeft: 5,
                    display: "inline-block",
                  }}>
                  <div className="linear-background"></div>
                </div>
              </h3>
            </div>
          </div>
        </div>
        <div className="news">
          <h3>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <g>
                <path fill="none" d="M0 0h24v24H0z"></path>
                <path d="M4.929 2.929l1.414 1.414A7.975 7.975 0 0 0 4 10c0 2.21.895 4.21 2.343 5.657L4.93 17.07A9.969 9.969 0 0 1 2 10a9.969 9.969 0 0 1 2.929-7.071zm14.142 0A9.969 9.969 0 0 1 22 10a9.969 9.969 0 0 1-2.929 7.071l-1.414-1.414A7.975 7.975 0 0 0 20 10c0-2.21-.895-4.21-2.343-5.657L19.07 2.93zM7.757 5.757l1.415 1.415A3.987 3.987 0 0 0 8 10c0 1.105.448 2.105 1.172 2.828l-1.415 1.415A5.981 5.981 0 0 1 6 10c0-1.657.672-3.157 1.757-4.243zm8.486 0A5.981 5.981 0 0 1 18 10a5.981 5.981 0 0 1-1.757 4.243l-1.415-1.415A3.987 3.987 0 0 0 16 10a3.987 3.987 0 0 0-1.172-2.828l1.415-1.415zM12 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm-1 2h2v8h-2v-8z"></path>
              </g>
            </svg>
            Latest News
          </h3>

          <div className="news__articles">
            <div className="news__nothing">
              <svg
                enableBackground="new 0 0 512 512"
                viewBox="0 0 512 512"
                xmlns="http://www.w3.org/2000/svg">
                <g>
                  <path d="m60 272h332v-152h-332zm30-122h272v92h-272z"></path>
                  <path d="m60 302h151v30h-151z"></path>
                  <path d="m60 362h151v30h-151z"></path>
                  <path d="m241 452h151v-150h-151zm30-120h91v90h-91z"></path>
                  <path d="m60 422h151v30h-151z"></path>
                  <path d="m60 0v60h-60v407c0 24.813 20.187 45 45 45h421.979c.172 0 .345-.001.518-.003 24.584-.268 44.503-20.351 44.503-44.997v-467zm-15 482c-8.271 0-15-6.729-15-15v-377h392v377c0 5.197.87 10.251 2.543 15zm437-15c0 8.174-6.571 14.841-14.708 14.997-4.094.084-7.857-1.43-10.75-4.244-2.929-2.85-4.542-6.669-4.542-10.753v-407h-362v-30h392z"></path>
                </g>
              </svg>
              <h3>Sorry, we couldn't find any related news.</h3>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="stockPage__keyStats">
      <div className="Key-info">
        <h3>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <g>
              <path fill="none" d="M0 0h24v24H0z"></path>
              <path d="M12 22C6.477 22 2 17.523 2 12c0-4.478 2.943-8.268 7-9.542v2.124A8.003 8.003 0 0 0 12 20a8.003 8.003 0 0 0 7.418-5h2.124c-1.274 4.057-5.064 7-9.542 7zm9.95-9H11V2.05c.329-.033.663-.05 1-.05 5.523 0 10 4.477 10 10 0 .337-.017.671-.05 1zM13 4.062V11h6.938A8.004 8.004 0 0 0 13 4.062z"></path>
            </g>
          </svg>
          Key Informations
        </h3>
        <div className="Key-info__columns">
          <div className="Key-info__info">
            <h4 className="Key-info__label">Market Cap</h4>
            <h3>{formatCurrency(coinInfo?.marketCap, "compact")}</h3>
          </div>
          <div className="Key-info__info">
            <h4 className="Key-info__label">Coin Rank</h4>
            <h3>{coinInfo?.rank}</h3>
          </div>
          <div className="Key-info__info">
            <h4 className="Key-info__label">All Time High</h4>
            <h3>
              {formatCurrency(coinInfo?.allTimeHigh?.price, "standard", "USD")}
            </h3>
          </div>
          <div className="Key-info__info">
            <h4 className="Key-info__label">24h volume</h4>
            <h3>{formatCurrency(coinInfo["24hVolume"], "compact")}</h3>
          </div>
          <div className="Key-info__info">
            <h4 className="Key-info__label">Circulating supply</h4>
            <h3>{formatNumber(coinInfo?.supply?.circulating, "compact")}</h3>
          </div>
          <div className="Key-info__info">
            <h4 className="Key-info__label">Max supply</h4>
            <h3>{formatNumber(coinInfo?.supply?.max, "compact")}</h3>
          </div>
        </div>
      </div>
      <div className="news">
        <h3>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <g>
              <path fill="none" d="M0 0h24v24H0z"></path>
              <path d="M4.929 2.929l1.414 1.414A7.975 7.975 0 0 0 4 10c0 2.21.895 4.21 2.343 5.657L4.93 17.07A9.969 9.969 0 0 1 2 10a9.969 9.969 0 0 1 2.929-7.071zm14.142 0A9.969 9.969 0 0 1 22 10a9.969 9.969 0 0 1-2.929 7.071l-1.414-1.414A7.975 7.975 0 0 0 20 10c0-2.21-.895-4.21-2.343-5.657L19.07 2.93zM7.757 5.757l1.415 1.415A3.987 3.987 0 0 0 8 10c0 1.105.448 2.105 1.172 2.828l-1.415 1.415A5.981 5.981 0 0 1 6 10c0-1.657.672-3.157 1.757-4.243zm8.486 0A5.981 5.981 0 0 1 18 10a5.981 5.981 0 0 1-1.757 4.243l-1.415-1.415A3.987 3.987 0 0 0 16 10a3.987 3.987 0 0 0-1.172-2.828l1.415-1.415zM12 12a2 2 0 1 1 0-4 2 2 0 0 1 0 4zm-1 2h2v8h-2v-8z"></path>
            </g>
          </svg>
          Latest News
        </h3>

        <div className="news__articles">
          <div className="news__nothing">
            <svg
              enableBackground="new 0 0 512 512"
              viewBox="0 0 512 512"
              xmlns="http://www.w3.org/2000/svg">
              <g>
                <path d="m60 272h332v-152h-332zm30-122h272v92h-272z"></path>
                <path d="m60 302h151v30h-151z"></path>
                <path d="m60 362h151v30h-151z"></path>
                <path d="m241 452h151v-150h-151zm30-120h91v90h-91z"></path>
                <path d="m60 422h151v30h-151z"></path>
                <path d="m60 0v60h-60v407c0 24.813 20.187 45 45 45h421.979c.172 0 .345-.001.518-.003 24.584-.268 44.503-20.351 44.503-44.997v-467zm-15 482c-8.271 0-15-6.729-15-15v-377h392v377c0 5.197.87 10.251 2.543 15zm437-15c0 8.174-6.571 14.841-14.708 14.997-4.094.084-7.857-1.43-10.75-4.244-2.929-2.85-4.542-6.669-4.542-10.753v-407h-362v-30h392z"></path>
              </g>
            </svg>
            <h3>Sorry, we couldn't find any related news.</h3>
          </div>
        </div>
      </div>
    </div>
  );
}
