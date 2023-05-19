import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { formatCurrency } from "@/helpers";
import Image from "next/image";
import { addBookmark, removeBookmark } from "@/helpers";
import { useSupabaseClient, useUser } from "@supabase/auth-helpers-react";

// const getCoinPrice = async (coinUuid) => {
//   const data = await fetch(`/api/getCoinInfo?uuid=${coinUuid}`, {
//     next: { revalidate: 10 },
//   });
//   const coin = await data.json();
//   return coin;
// };

import { motion } from "framer-motion";

export default function Buy({ onClick, inputRef, coin }) {
  const supabase = useSupabaseClient();
  const user = useUser();
  const router = useRouter();
  const [isBookmarked, setIsBookmarked] = useState(false);
  // let coinUuid = router.query.uuid;

  const [coinInfo, setCoinInfo] = useState(coin);
  //   console.log(coinUuid);
  const getCoinInfo = async (coinUuid) => {
    // return { error: true };
    const data = await fetch(`/api/getCoinInfo?uuid=${coinUuid}`);
    const coin = await data.json();
    return coin;
  };

  useEffect(() => {
    const coinUuid = window.location.pathname.split("/")[2];
    //get coin info if error wait 5 seconds and try again until success
    const interval = setInterval(async () => {
      const coin = await getCoinInfo(coinUuid);
      if (!coin.error) {
        setCoinInfo(coin);
        console.log(coin.price);
        clearInterval(interval);
      } else {
        console.log("retrying", coinUuid, router.query);
      }
    }, 5000);

    const checkBookmark = async () => {
      const { data, error } = await supabase
        .from("bookmarks")
        .select("*")
        .eq("userID", user.id)
        .eq("coinUUID", coinUuid);
      if (data.length > 0) {
        setIsBookmarked(true);
      }
    };
    if (user) {
      checkBookmark();
    }
    return () => clearInterval(interval);
  }, []);
  // useEffect(() => {
  //   const coinUuid = window.location.pathname.split("/")[2];
  //   getCoinPrice(coinUuid).then((coin) => {
  //     setCoinInfo(coin);
  //   });
  // }, [router.query]);

  useEffect(() => {
    //upadate price every 10 seconds
    const interval = setInterval(async () => {
      const coinUuid = window.location.pathname.split("/")[2];
      const coin = await getCoinInfo(coinUuid);
      if (!coin.error) {
        console.log("updating price");
        setCoinInfo(coin);
        console.log(coin.price);
      } else {
        console.log("retrying", coinUuid);
      }
    }, 10000);
    return () => clearInterval(interval);
  }, []);
  const set = () => {
    setIsVisible(true);
  };

  if (!coinInfo || !user)
    return (
      <div className="stockPage__trade">
        <div className="stockPage__mobile">
          <div
            style={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "flex-start",
              alignItems: "flex-start",
            }}>
            <div style={{ width: 25, height: 25 }}>
              <div className="linear-background"></div>
            </div>

            {/* <img width={25} height={25} src={coinInfo?.iconUrl} alt="hehe" /> */}
            {/* <h4 style={{ padding: 5 }}>{coinInfo?.name}</h4> */}
            <div
              style={{
                width: 100,
                height: 25,
                marginLeft: 5,
              }}>
              <div className="linear-background"></div>
            </div>
            <motion.svg
              animate={{ x: 0 }}
              id="bookmark"
              xmlns="http://www.w3.org/2000/svg"
              width="25"
              height="25"
              viewBox="0 0 24 24"
              fill="none"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              stroke="#ddd"
              style={{ cursor: "pointer", marginLeft: "auto", x: 100 }}>
              <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
            </motion.svg>
          </div>
          <div className="stockPage__trade-top">
            <h2 id="latestprice">
              {process.env.NEXT_PUBLIC_REFERENCE_CURRENCY_SYMBOL}
              <div
                style={{
                  width: 100,
                  height: 25,
                  marginLeft: 5,
                  display: "inline-block",
                }}>
                <div className="linear-background"></div>
              </div>
            </h2>

            <h6
              style={{
                color:
                  coinInfo?.change > 0
                    ? "rgb(58, 232, 133)"
                    : "rgb(244, 83, 133)",
              }}>
              <div
                style={{
                  width: 40,
                  height: 15,
                  marginLeft: 5,
                  marginRight: 5,
                  display: "inline-block",
                }}>
                <div className="linear-background"></div>
              </div>
              %
            </h6>
          </div>
        </div>
        {/* <!-- <h6>
                      Extended Hours:
                      <span style={{"color":"rgb(244, 83, 133)"}}>$24.18 (-0.26)</span>
                    </h6> --> */}
        <h5>
          Buy{" "}
          <div
            style={{
              width: 40,
              height: 10,
              marginLeft: 5,
              display: "inline-block",
            }}>
            <div className="linear-background"></div>
          </div>
        </h5>
        <div className="stockPage__buy-container">
          <input
            autoCorrect="off"
            autoCapitalize="off"
            spellCheck="false"
            className="stockPage__buy-input"
            id="buy_input"
            type="number"
          />
          <button className="stockPage__buy-button" onClick={null}>
            BUY
          </button>
        </div>
      </div>
    );

  return (
    <motion.div
      className="stockPage__trade"
      style={{ x: 100 }}
      animate={{ x: 0 }}>
      <div className="stockPage__mobile">
        <div
          style={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "flex-start",
            alignItems: "flex-start",
          }}>
          <Image width={25} height={25} src={coinInfo?.iconUrl} alt="hehe" />
          <h4 style={{ padding: 5 }}>{coinInfo?.name}</h4>
          <svg
            onClick={() => {
              if (!isBookmarked) {
                addBookmark(supabase, {
                  userID: user?.id,
                  coinUUID: coinInfo?.uuid,
                });
              } else {
                removeBookmark(supabase, {
                  userID: user?.id,
                  coinUUID: coinInfo?.uuid,
                });
              }

              setIsBookmarked(!isBookmarked);
            }}
            id="bookmark"
            xmlns="http://www.w3.org/2000/svg"
            width="25"
            height="25"
            viewBox="0 0 24 24"
            fill="none"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            stroke="#ddd"
            style={{
              cursor: "pointer",
              marginLeft: "auto",
              fill: isBookmarked ? "rgb(221,221,221)" : "none",
            }}>
            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
          </svg>
        </div>
        <div className="stockPage__trade-top">
          <h2 id="latestprice">{formatCurrency(coinInfo?.price)}</h2>

          <h6
            style={{
              color:
                coinInfo?.change > 0
                  ? "rgb(58, 232, 133)"
                  : "rgb(244, 83, 133)",
            }}>
            {coinInfo?.change}%
          </h6>
        </div>
      </div>
      {/* <!-- <h6>
                    Extended Hours:
                    <span style={{"color":"rgb(244, 83, 133)"}}>$24.18 (-0.26)</span>
                  </h6> --> */}
      <h5>Buy {coinInfo?.symbol}</h5>
      <div className="stockPage__buy-container">
        <input
          ref={inputRef}
          autoCorrect="off"
          autoCapitalize="off"
          spellCheck="false"
          className="stockPage__buy-input"
          id="buy_input"
          type="number"
        />
        <button className="stockPage__buy-button" onClick={() => onClick(true)}>
          BUY
        </button>
      </div>
    </motion.div>
  );
}
