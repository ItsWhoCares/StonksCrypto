import { useSupabaseClient, useUser } from "@supabase/auth-helpers-react";
import { useState, useEffect } from "react";
import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";
import Topbar from "@/components/Elements/topbar";
import { getPortfolio } from "@/helpers";
import Link from "next/link";
import { formatCurrency } from "@/helpers";
import { createSellTransaction } from "@/helpers";

export default function Portfolio() {
  const supabase = useSupabaseClient();
  const user = useUser();
  const [portfolio, setPortfolio] = useState();
  useEffect(() => {
    if (user) {
      getPortfolio(supabase, user.id).then((data) => {
        setPortfolio(data);
      });
    }
  }, [user]);
  const sell = (buyID) => {
    if (!user) return;
    createSellTransaction(supabase, { userID: user.id, buyID }).then((data) => {
      getPortfolio(supabase, user.id).then((data) => {
        setPortfolio(data);
      });
    });
  };

  return (
    <main id="root">
      <div className={"container"}>
        <div className={"portfolio"}>
          <div
            style={{
              display: "flex",
              width: "100%",
              flexDirection: "column",
            }}>
            <div style={{ display: "flex", height: "100%" }}>
              <Leftbar page={"portfolio"} />
              <div
                className={"portfolio__container"}
                style={{ padding: "3%", paddingTop: "2%", width: "100%" }}>
                <LeftbarMobile />

                <Topbar />

                {portfolio?.length > 0 ? (
                  <table className={"portfolio__list"} id="bookmarkstable">
                    <tbody>
                      <tr>
                        <th>SYMBOL</th>
                        <th>NAME</th>
                        <th></th>
                        <th>CHANGE (%)</th>
                        <th>CURRENT VALUE</th>
                        <th></th>
                      </tr>
                      {portfolio.map((coin) => (
                        <tr key={coin.buyID}>
                          <td>
                            <Link href={`/coin/${coin.coinUUID}`}>
                              {coin.symbol}
                            </Link>
                          </td>
                          <td>{coin.name}</td>

                          {/* {coin.change < 0 ? (
                              <td style={{ color: "rgb(244, 83, 133)" }}></td>
                              <td style={{ color: "rgb(244, 83, 133)" }}>
                                {coin.change}%
                              </td>
                            ) : (
                                <td style={{ color: "rgb(102, 249, 218)" }}></td>
                                <td style={{ color: "rgb(102, 249, 218)" }}>
                                    +{coin.change}%
                                </td>
                            )} */}
                          {coin.change < 0 ? (
                            <>
                              {" "}
                              <td style={{ color: "rgb(244, 83, 133)" }}></td>
                              <td style={{ color: "rgb(244, 83, 133)" }}>
                                {coin.change}%
                              </td>
                            </>
                          ) : (
                            <>
                              <td style={{ color: "rgb(102, 249, 218)" }}></td>
                              <td style={{ color: "rgb(102, 249, 218)" }}>
                                +{coin.change}%
                              </td>
                            </>
                          )}

                          <td>{formatCurrency(coin.currentPrice)}</td>
                          <td>
                            <button
                              className={"stockPage__sell-button"}
                              onClick={() => sell(coin.buyID)}>
                              SELL
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <div style={{ display: "flex", height: "80vh" }}>
                    <div className="errorMsg" id="error">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 24 24"
                        width={10}
                        height={10}>
                        <g>
                          <path fill="none" d="M0 0h24v24H0z"></path>
                          <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                        </g>
                      </svg>

                      <h3>You didn't buy any stocks yet.</h3>
                    </div>
                  </div>
                )}

                {/* <div className="errorMsg" style={{ display: "none" }} id="error">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <g>
                          <path fill="none" d="M0 0h24v24H0z"></path>
                          <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z"></path>
                        </g>
                      </svg>
    
                      <h3>You didn't bookmarked any stocks yet.</h3>
                    </div> */}
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
