import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/router";
import { useSupabaseClient, useUser } from "@supabase/auth-helpers-react";
import Topbar from "@/components/Elements/topbar";
import Buy from "@/components/Elements/buy";
import KeyInfo from "@/components/KeyInfo/KeyInfo";
import FChart from "@/components/Chart/FChart";
import Link from "next/link";
import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";
import { formatCurrency } from "@/helpers";
import { createBuyTransaction } from "@/helpers";
import ConfirmBox from "./confirmBox";
import Head from "next/head";

export const metadata = {
  title: "...",
  description: "...",
};

// export const revalidate = 1;
export default function Coin() {
  const router = useRouter();
  const inputRef = useRef();

  const coinUuid = router.query.uuid;
  const user = useUser();
  const supabase = useSupabaseClient();
  const [coinInfo, setCoinInfo] = useState();
  const [isVisible, setIsVisible] = useState(false);
  const [errorMsg, setErrorMsg] = useState(null);
  const getCoinInfo = async (uuid) => {
    const res = await fetch(`/api/getCoinInfo?uuid=${uuid}`);
    const data = await res.json();
    return data;
  };
  useEffect(() => {
    const uuid = window.location.pathname.split("/")[2];
    getCoinInfo(uuid).then((data) => {
      setCoinInfo(data);
    });
  }, []);
  const buyCoin = async () => {
    const res1 = await fetch(`/api/getCoinPrice?uuid=${coinUuid}`);
    const data = await res1.json();
    const coinPrice = data?.price;
    if (!data.error) {
      const res = await createBuyTransaction(supabase, {
        userID: user?.id,
        coinUUID: coinInfo?.uuid,
        coinPrice,
        quantity: inputRef?.current?.value,
      });

      if (res.error) {
        setErrorMsg(res.errorMsg);
        console.log(errorMsg, "herererere");
      } else {
        setIsVisible(false);
      }
    }
  };
  // const set = () => {
  //   console.log("before", isVisible);
  //   setIsVisible(!isVisible);
  //   console.log("afterset", isVisible);
  // };
  // const set = useCallback((value) => {
  //   console.log("before", isVisible);
  //   setIsVisible(value);
  //   console.log("afterset", isVisible);
  // }, []);
  return (
    <>
    <Head>
        <title>{coinInfo?.name} | StonksCrypto</title>
    </Head>
      <main id="root">
        <div className="container">
          <section className="stock">
            {isVisible && (
              <ConfirmBox
                quantity={inputRef?.current?.value}
                setIsVisible={setIsVisible}
                buyCoin={buyCoin}
                coinPrice={coinInfo?.price}
                error={errorMsg ? true : false}
                errorMsg={errorMsg}
                setErrorMsg={setErrorMsg}
              />
            )}

            <div style={{ display: "flex", height: "100%" }}>
              <Leftbar page={"coin"} />
              <div className="stockPage">
                <LeftbarMobile />
                <Topbar />
                <div className="stockPage__top">
                  <FChart />

                  <Buy onClick={setIsVisible} inputRef={inputRef} />
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
