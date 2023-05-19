import Leftbar from "@/components/Elements/leftbar";
import LeftbarMobile from "@/components/Elements/leftBarMobile";
import Topbar from "@/components/Elements/topbar";
import { useEffect, useState } from "react";
import { formatCurrency, getBookmarks, removeBookmark } from "@/helpers";
import {
  useSupabaseClient,
  useUser,
  useSession,
} from "@supabase/auth-helpers-react";
import Link from "next/link";
import Head from "next/head";
export default function Watchlist() {
  const user = useUser();
  const supabase = useSupabaseClient();
  const [bookmarks, setBookmarks] = useState([]);
  useEffect(() => {
    if (!user) return;
    getBookmarks(supabase, user?.id).then((data) => {
      setBookmarks(data);
    });
  }, [user]);
  // useEffect(() => {
  //   const bookmarks = supabase
  //     .channel("custom-delete-channel")
  //     .on(
  //       "postgres_changes",
  //       { event: "DELETE", schema: "public", table: "bookmarks" },
  //       (payload) => {
  //         console.log("Change received!", payload);
  //         setBookmarks((prev) => {
  //           return prev.filter(
  //             (coin) => coin.coinUUID !== payload.old.coinUUID
  //           );
  //         });
  //       }
  //     )
  //     .subscribe();
  //   return () => {
  //     bookmarks.unsubscribe();
  //   };
  // }, [user]);
  // const session = useSession();
  // useEffect(() => {
  //   if (!session) {
  //     router.push("/");
  //   }
  // }, [session]);
  return (
    <>
      <Head>
        <title>Watchlist | StonksCrypto</title>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <link rel="icon" type="image/png" href="/favicon.png" />
      </Head>
      <main id="root">
        <div className="container">
          <div className="portfolio">
            <div
              style={{
                display: "flex",
                width: "100%",
                flexDirection: "column",
              }}>
              <div style={{ display: "flex", height: "100%" }}>
                <Leftbar page={"watchlist"} />
                <div
                  className="portfolio__container"
                  style={{ padding: "3%", paddingTop: "2%", width: "100%" }}>
                  <LeftbarMobile />

                  <Topbar />

                  {bookmarks?.length > 0 ? (
                    <table className="portfolio__list" id="bookmarkstable">
                      <tbody>
                        <tr>
                          <th>SYMBOL</th>
                          <th>NAME</th>
                          <th></th>
                          <th>CHANGE (%)</th>
                          <th>CURRENT VALUE</th>
                          <th></th>
                        </tr>
                        {bookmarks.map((coin) => (
                          <tr key={coin.coinUUID}>
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
                                <td
                                  style={{ color: "rgb(102, 249, 218)" }}></td>
                                <td style={{ color: "rgb(102, 249, 218)" }}>
                                  +{coin.change}%
                                </td>
                              </>
                            )}

                            <td>{formatCurrency(coin.price)}</td>

                            <td>
                              <svg
                                onClick={async () => {
                                  await removeBookmark(supabase, {
                                    userID: user.id,
                                    coinUUID: coin.coinUUID,
                                  });
                                  //reload
                                  getBookmarks(supabase, user?.id).then(
                                    (data) => {
                                      setBookmarks(data);
                                    }
                                  );
                                }}
                                id="bookmark"
                                xmlns="http://www.w3.org/2000/svg"
                                width="25"
                                height="25"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke-width="2"
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke="#ddd"
                                style={{
                                  fill: "rgb(221, 221, 221)",
                                  cursor: "pointer",
                                }}>
                                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                              </svg>
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

                        <h3>You didn't bookmarked any stocks yet.</h3>
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
        {/* <script>
        {`
                              const bookmark = document.getElementById("bookmark");
                              bookmark.addEventListener("click", () => {
                                //remove row
                                bookmark.parentElement.parentElement.remove();
                                
                              });
                            `}
      </script> */}
      </main>
    </>
  );
}
//   return (
//     <>
//       <main id="root">
//         <div className="container">
//           <div className="portfolio">
//             <div
//               style={{
//                 display: "flex",
//                 flexDirection: "column",
//                 width: "100%",
//               }}>
//               <div style={{ display: "flex", height: "100%" }}>
//                 <Leftbar />

//                 <div className="panel">
//                   <LeftbarMobile />
//                   <Topbar />
//                   {/* {this.state.loader1 === "" && <WatchLoader />} */}
//                   {/* {this.state.loader1 === true && watchlist.length > 0 && (
//         <table className="portfolio__list">
//           <tbody>
//             <tr>
//               <th>SYMBOL</th>
//               <th>NAME</th>
//               <th></th>
//               <th>CHANGE (%)</th>
//               <th>CURRENT VALUE</th>
//               <th />
//             </tr>
//             {watchlist.map((val, index) => {
//               return (
//                 <tr key={index}>
//                   <td>
//                     <Link to={"stocks/" + watchlist[parseInt(index)]}>
//                       {val}
//                     </Link>
//                   </td>
//                   <td>{stockName[parseInt(index)]}</td>
//                   <td style={{ color: color[parseInt(index)] }}></td>
//                   <td style={{ color: color[parseInt(index)] }}>
//                     {change[parseInt(index)]}
//                   </td>
//                   <td>${value[parseInt(index)]}</td>
//                   <td>
//                     <svg
//                       id="bookmark"
//                       xmlns="http://www.w3.org/2000/svg"
//                       width="25"
//                       height="25"
//                       viewBox="0 0 24 24"
//                       fill="none"
//                       stroke-width="2"
//                       stroke-linecap="round"
//                       stroke-linejoin="round"
//                       stroke="#ddd"
//                       style={{
//                         fill: "#ddd",
//                         cursor: "pointer",
//                       }}
//                       onClick={() => {
//                         this.handleWatchlist(watchlist[parseInt(index)]);
//                       }}>
//                       <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
//                     </svg>
//                   </td>
//                 </tr>
//               );
//             })}
//           </tbody>
//         </table>
//       )} */}

//                   <div className="errorMsg">
//                     <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
//                       <g>
//                         <path fill="none" d="M0 0h24v24H0z" />
//                         <path d="M5.373 4.51A9.962 9.962 0 0 1 12 2c5.523 0 10 4.477 10 10a9.954 9.954 0 0 1-1.793 5.715L17.5 12H20A8 8 0 0 0 6.274 6.413l-.9-1.902zm13.254 14.98A9.962 9.962 0 0 1 12 22C6.477 22 2 17.523 2 12c0-2.125.663-4.095 1.793-5.715L6.5 12H4a8 8 0 0 0 13.726 5.587l.9 1.902zm-5.213-4.662L10.586 12l-2.829 2.828-1.414-1.414 4.243-4.242L13.414 12l2.829-2.828 1.414 1.414-4.243 4.242z" />
//                       </g>
//                     </svg>
//                     <h3>You didn't bookmarked any stocks yet.</h3>
//                   </div>
//                 </div>
//               </div>
//               ;
//             </div>
//           </div>
//         </div>
//       </main>
//     </>
//   );
// }
