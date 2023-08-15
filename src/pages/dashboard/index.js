// export { default } from "./dashboard";

import { useState, useEffect } from "react";
import { useRouter } from "next/router";
import {
  useSession,
  useSupabaseClient,
  useUser,
} from "@supabase/auth-helpers-react";
// import Leftbar from "../../components/Elements/leftbar";
// import Topbar from "../../components/Elements/topbar";
// import Loader from "@/components/Elements/loader";
import Link from "next/link";
import "@/styles/Dashboard.module.css";
import Topbar from "@/components/Elements/topbar";
import {
  formatCurrency,
  getPortfolio,
  getUserAllTransactions,
  getUserNetWorth,
} from "@/helpers";
import DashLoading from "../../components/Elements/dashLoading";
import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";
import Head from "next/head";

import { motion } from "framer-motion";

export const metadata = {
  title: "...",
  description: "...",
};

import { server } from "../../../config";
import MostActive from "@/components/Elements/mostActive";
import PortChart from "@/components/Chart/PortChart";

const getTopCoins = async () => {
  // return { error: true };
  const res = await fetch(`${server}/api/getTopCoins`);
  const data = await res.json();
  return data;
};

// function sleep(ms) {
//   return new Promise((resolve) => setTimeout(resolve, ms));
// }

export async function getStaticProps() {
  // console.log("getStaticProps");
  // Get external data from the file system, API, DB, etc.
  // const data = ...

  // The value of the `props` key will be
  //  passed to the `Home` component

  const data = await getTopCoins();

  return {
    props: {
      topCoins: data,
    },
  };
}

const selectedVariants = {
  1: "Market Cap",
  2: "Volume",
};

export default function Dashboard(props) {
  const session = useSession();
  const supabase = useSupabaseClient();
  const router = useRouter();
  const [selectedSort, setSelectedSort] = useState(1);
  const [isHovering, setIsHovering] = useState(false);

  const user = useUser();
  const [netWorth, setNetWorth] = useState(0);
  const [portfolio, setPortfolio] = useState([]);
  useEffect(() => {
    if (user) {
      getPortfolio(supabase, user.id).then((data) => {
        setPortfolio(data);
        getUserNetWorth(supabase, user.id).then((NetWorth) => {
          setNetWorth(NetWorth);
        });
      });
    }
  }, [user]);

  useEffect(() => {
    if (!session) {
      console.log("no session");
      router.push("/");
    }
  }, [session]);

  const [topCoins, setTopCoins] = useState(props.topCoins);

  const getTopCoins = async () => {
    // return { error: true };
    const res = await fetch("/api/getTopCoins");
    const data = await res.json();
    setTopCoins(data);
  };
  const getTopByVolume = async () => {
    // return { error: true };

    const res = await fetch("/api/getTopByVolume");
    const data = await res.json();
    // console.log(data);
    // return data;
    setTopCoins(data);
  };

  useEffect(() => {
    if (selectedSort == 1) {
      getTopCoins();
    } else if (selectedSort == 2) {
      getTopByVolume();
    }
  }, [selectedSort]);

  //   useEffect(() => {
  //     const interval = setInterval(async () => {
  //       const coins = await getTopCoins();
  //       if (!coins.error) {
  //         setTopCoins(coins);
  //         clearInterval(interval);
  //       }
  //     }, 5000);
  //     return () => clearInterval(interval);
  //   }, []);

  const [isOpen, setIsOpen] = useState(false);

  if (!topCoins) {
    return (
      <>
        <Head>
          <title>Dashboard | StonksCrypto</title>
          <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
          <link rel="icon" type="image/png" href="/favicon.png" />
        </Head>
        <>
          <main id="root">
            <div className="container">
              <section className="Dashboard" id="dashboard">
                <div></div>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    width: "100%",
                  }}>
                  <div style={{ display: "flex", height: "100%" }}>
                    <Leftbar page={"dashboard"} />

                    <div className="panel">
                      <LeftbarMobile />
                      <Topbar />

                      <div className="panel__container">
                        <div className="panel__top">
                          <div className="panel__title">
                            <div
                              style={{
                                display: "flex",
                                alignItems: "center",
                                width: "33%",
                              }}>
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="panel__portfolio-title"
                                viewBox="0 0 24 24">
                                <g>
                                  <path fill="none" d="M0 0h24v24H0z"></path>
                                  <path d="M4.873 3h14.254a1 1 0 0 1 .809.412l3.823 5.256a.5.5 0 0 1-.037.633L12.367 21.602a.5.5 0 0 1-.706.028c-.007-.006-3.8-4.115-11.383-12.329a.5.5 0 0 1-.037-.633l3.823-5.256A1 1 0 0 1 4.873 3zm.51 2l-2.8 3.85L12 19.05 21.417 8.85 18.617 5H5.383z"></path>
                                </g>
                              </svg>
                              <h3>Portfolio</h3>
                            </div>
                          </div>
                          <div
                            className="panel__topCharts"
                            style={{ display: "flex" }}>
                            <div className="panel__portfolio-section">
                              <div className="panel__portfolio" id="portfolio">
                                <div className="errorMsg">
                                  <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    viewBox="0 0 24 24">
                                    <g>
                                      <path
                                        fill="none"
                                        d="M0 0h24v24H0z"></path>
                                      <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                                    </g>
                                  </svg>
                                  <p>You didn't buy any stocks yet.</p>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <DashLoading />
                    </div>
                  </div>
                </div>
              </section>
            </div>
          </main>
        </>
      </>
    );
  } else
    return (
      <>
        <Head>
          <title>Dashboard | StonksCrypto</title>
          <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
          <link rel="icon" type="image/png" href="/favicon.png" />
        </Head>
        <>
          <main id="root">
            <div className="container">
              <section className="Dashboard" id="dashboard">
                <div></div>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    width: "100%",
                  }}>
                  <div style={{ display: "flex", height: "100%" }}>
                    <Leftbar page={"dashboard"} />

                    <div className="panel">
                      <LeftbarMobile />
                      <Topbar />

                      <div className="panel__container">
                        <div className="panel__top">
                          <motion.div
                            onClick={() => {
                              router.push("/portfolio");
                            }}
                            style={{ cursor: "pointer" }}
                            className="panel__title"
                            whileHover={{ scale: 1.2 }}
                            whileTap={{ scale: 0.95 }}
                            transition={{
                              type: "spring",
                              stiffness: 400,
                              damping: 17,
                            }}>
                            <div
                              style={{
                                display: "flex",
                                alignItems: "center",
                                width: "33%",
                              }}>
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                className="panel__portfolio-title"
                                viewBox="0 0 24 24">
                                <g>
                                  <path fill="none" d="M0 0h24v24H0z"></path>
                                  <path d="M4.873 3h14.254a1 1 0 0 1 .809.412l3.823 5.256a.5.5 0 0 1-.037.633L12.367 21.602a.5.5 0 0 1-.706.028c-.007-.006-3.8-4.115-11.383-12.329a.5.5 0 0 1-.037-.633l3.823-5.256A1 1 0 0 1 4.873 3zm.51 2l-2.8 3.85L12 19.05 21.417 8.85 18.617 5H5.383z"></path>
                                </g>
                              </svg>
                              <h3>Portfolio</h3>
                            </div>
                          </motion.div>
                          <div
                            style={{
                              display: "flex",
                            }}>
                            {portfolio.length > 0 ? (
                              <div
                                className="panel__topCharts"
                                style={{
                                  display: "flex",
                                  minWidth: "30%",
                                  marginLeft: "5px",
                                }}>
                                <div className="panel__portfolio-section">
                                  <div
                                    className="panel__portfolio"
                                    id="portfolio"
                                    style={{ display: "block" }}>
                                    <div>
                                      <table className="panel__portfolio-list">
                                        <tbody>
                                          <tr>
                                            <th>SYMBOL</th>
                                            <th>QUANTITY</th>
                                            <th>GAIN/LOSS (%)</th>
                                            <th>CURRENT VALUE</th>
                                          </tr>
                                          {portfolio.map((coin) => (
                                            <tr key={Math.random()}>
                                              <td>{coin.symbol}</td>
                                              <td>{coin.quantity}</td>
                                              <td
                                                style={
                                                  coin.change > 0
                                                    ? {
                                                        color:
                                                          "rgb(102, 249, 218)",
                                                      }
                                                    : {
                                                        color:
                                                          "rgb(244, 83, 133)",
                                                      }
                                                }>
                                                {coin.change}%
                                              </td>
                                              <td>
                                                {formatCurrency(
                                                  coin.currentPrice
                                                )}
                                              </td>
                                            </tr>
                                          ))}
                                          {/* <tr>
                                          <td>AMZN</td>
                                          <td>10</td>
                                          <td style="color: rgb(102, 249, 218);">
                                            +0.00%
                                          </td>
                                          <td>$1,160.05</td>
                                        </tr> */}
                                        </tbody>
                                      </table>
                                      <div className="panel__value">
                                        <h5>NET WORTH</h5>
                                        <h5>{formatCurrency(netWorth)}</h5>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            ) : (
                              <div
                                className="panel__topCharts"
                                style={{
                                  display: "flex",
                                }}>
                                <div className="panel__portfolio-section">
                                  <div
                                    className="panel__portfolio"
                                    id="portfolio">
                                    <div className="errorMsg">
                                      <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 24 24">
                                        <g>
                                          <path
                                            fill="none"
                                            d="M0 0h24v24H0z"></path>
                                          <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                                        </g>
                                      </svg>
                                      <p>You didn't buy any stocks yet.</p>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            )}
                            <div
                              className="panel__topCharts"
                              style={{
                                display: "flex",
                                paddingLeft: "5vw",
                              }}>
                              <div className="panel__portfolio-section">
                                <div
                                  className="panel__portfolio"
                                  id="portfolio">
                                  <PortChart />
                                  {/* <div className="errorMsg">
                                    <svg
                                      xmlns="http://www.w3.org/2000/svg"
                                      viewBox="0 0 24 24">
                                      <g>
                                        <path
                                          fill="none"
                                          d="M0 0h24v24H0z"></path>
                                        <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                                      </g>
                                    </svg>
                                    <p>You didn't buy any stocks yet.</p>
                                  </div> */}
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div className="panel__low">
                        <motion.div
                          // onHoverStart={() => {
                          //   setIsHovering(true);
                          // }}
                          // onHoverEnd={() => {
                          //   setIsHovering(false);
                          // }}
                          onClick={() => {
                            setSelectedSort((prev) => {
                              prev < 2 ? prev++ : (prev = 1);
                              return prev;
                            });
                          }}
                          drag
                          dragSnapToOrigin={true}
                          whileDrag={{ scale: 1.2 }}
                          style={{ cursor: "pointer", width: "26%" }}
                          className="panel__bottom-title"
                          whileHover={{ scale: 1.2 }}
                          whileTap={{ scale: 0.95 }}
                          transition={{
                            type: "spring",
                            stiffness: 400,
                            damping: 17,
                          }}>
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24">
                            <g>
                              <path fill="none" d="M0 0h24v24H0z"></path>
                              <path
                                fillRule="nonzero"
                                d="M12 23a7.5 7.5 0 0 0 7.5-7.5c0-.866-.23-1.697-.5-2.47-1.667 1.647-2.933 2.47-3.8 2.47 3.995-7 1.8-10-4.2-14 .5 5-2.796 7.274-4.138 8.537A7.5 7.5 0 0 0 12 23zm.71-17.765c3.241 2.75 3.257 4.887.753 9.274-.761 1.333.202 2.991 1.737 2.991.688 0 1.384-.2 2.119-.595a5.5 5.5 0 1 1-9.087-5.412c.126-.118.765-.685.793-.71.424-.38.773-.717 1.118-1.086 1.23-1.318 2.114-2.78 2.566-4.462z"></path>
                            </g>
                          </svg>

                          <h3>
                            {"Most Active by " + selectedVariants[selectedSort]}
                          </h3>
                        </motion.div>
                        <MostActive topCoins={topCoins} />
                      </div>
                    </div>
                  </div>
                </div>
              </section>
            </div>
          </main>
        </>
      </>
    );
}
