import { useState, useEffect } from "react";
import { useRouter } from "next/router";
import { useSession, useSupabaseClient } from "@supabase/auth-helpers-react";
// import Leftbar from "../../components/Elements/leftbar";
// import Topbar from "../../components/Elements/topbar";
// import Loader from "@/components/Elements/loader";
import Link from "next/link";
import "@/styles/Dashboard.module.css";
import Topbar from "@/components/Elements/topbar";
import { formatCurrency } from "@/helpers";
import DashLoading from "./dashLoading";
import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";

export const metadata = {
  title: "...",
  description: "...",
};

const getTopCoins = async () => {
  // return { error: true };
  const res = await fetch("/api/getTopCoins");
  const data = await res.json();
  return data;
};

export async function getStaticProps() {
  console.log("getStaticProps");
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

export default function Dashboard(props) {
  console.log("props", props);
  const session = useSession();
  const supabase = useSupabaseClient();
  const router = useRouter();

  useEffect(() => {
    if (!session) {
      console.log("no session");
      router.push("/");
    }
  }, [session]);

  const [topCoins, setTopCoins] = useState();

  useEffect(() => {
    const interval = setInterval(async () => {
      const coins = await getTopCoins();
      if (!coins.error) {
        setTopCoins(coins);
        clearInterval(interval);
      }
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  if (!topCoins) {
    return (
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
                  <Leftbar />

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
                                    <path fill="none" d="M0 0h24v24H0z"></path>
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
    );
  } else
    return (
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
                  <Leftbar />

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
                                    <path fill="none" d="M0 0h24v24H0z"></path>
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
                    <div className="panel__low">
                      <div className="panel__bottom-title">
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
                        <h3>Most Active</h3>
                      </div>

                      <div className="panel__bottom">
                        <div className="panel__stockList">
                          <ul className="panel__list">
                            {/* first three topcoins only*/}
                            {topCoins.slice(0, 3).map((coin) => (
                              <li key={coin?.uuid}>
                                <Link href={`/coin/${coin.uuid}`}>
                                  <span className="panel__fullname">
                                    <h4>{coin.symbol}</h4>
                                    <h6 className="panel__name">{coin.name}</h6>
                                  </span>
                                  <div className="panel__list-change">
                                    {/* round to two decimal places */}
                                    <h4>{formatCurrency(coin.price)}</h4>

                                    {coin.change > 0 ? (
                                      <h5
                                        style={{
                                          color: "rgb(102, 249, 218)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                                        }}>
                                        +{coin.change}%
                                      </h5>
                                    ) : (
                                      <h5
                                        style={{
                                          color: "rgb(244, 84, 133)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                                        }}>
                                        {coin.change}%
                                      </h5>
                                    )}
                                  </div>
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                        <div className="panel__stockList">
                          <ul className="panel__list">
                            {topCoins.slice(3, 6).map((coin) => (
                              <li key={coin?.uuid}>
                                <Link href={`/coin/${coin.uuid}`}>
                                  <span className="panel__fullname">
                                    <h4>{coin.symbol}</h4>
                                    <h6 className="panel__name">{coin.name}</h6>
                                  </span>
                                  <div className="panel__list-change">
                                    {/* round to two decimal places */}
                                    <h4>{formatCurrency(coin.price)}</h4>

                                    {coin.change > 0 ? (
                                      <h5
                                        style={{
                                          color: "rgb(102, 249, 218)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                                        }}>
                                        +{coin.change}%
                                      </h5>
                                    ) : (
                                      <h5
                                        style={{
                                          color: "rgb(244, 84, 133)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                                        }}>
                                        {coin.change}%
                                      </h5>
                                    )}
                                  </div>
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                        <div className="panel__stockList">
                          <ul className="panel__list">
                            {topCoins.slice(6, 9).map((coin) => (
                              <li key={coin?.uuid}>
                                <Link href={`/coin/${coin.uuid}`}>
                                  <span className="panel__fullname">
                                    <h4>{coin.symbol}</h4>
                                    <h6 className="panel__name">{coin.name}</h6>
                                  </span>
                                  <div className="panel__list-change">
                                    {/* round to two decimal places */}
                                    <h4>{formatCurrency(coin.price)}</h4>
                                    {coin.change > 0 ? (
                                      <h5
                                        style={{
                                          color: "rgb(102, 249, 218)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                                        }}>
                                        +{coin.change}%
                                      </h5>
                                    ) : (
                                      <h5
                                        style={{
                                          color: "rgb(244, 84, 133)",
                                          margin: "5px 0px 0px",
                                          textShadow:
                                            "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                                        }}>
                                        {coin.change}%
                                      </h5>
                                    )}
                                  </div>
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </main>
      </>
    );
}
