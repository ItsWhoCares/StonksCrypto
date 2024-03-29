import Link from "next/link";
import {
  useSession,
  useSupabaseClient,
  useUser,
} from "@supabase/auth-helpers-react";
import { useRouter } from "next/router";
import { useEffect } from "react";

import { motion } from "framer-motion";

export default function Leftbar({ page }) {
  const supabase = useSupabaseClient();
  const session = useSession();
  const router = useRouter();

  //log out function
  const logout = () => {
    supabase.auth.signOut();
    router.push("/");
  };

  // useEffect(() => {
  //   if (!session) {
  //     router.push("/");
  //   }
  // }, [session]);

  // const router = useRouter();

  // const logout = async () => {
  //   console.log("logout");
  //   const { error } = await supabase.auth.signOut();
  //   if (error) console.log("Error signing out:", error.message);
  //   else router.push("/");
  // };

  // return (
  //   <aside className="leftbar">
  //     <svg
  //       className="leftbar__logo"
  //       xmlns="http://www.w3.org/2000/svg"
  //       viewBox="0 0 24 24">
  //       <g>
  //         <path fill="none" d="M0 0h24v24H0z" />
  //         <path d="M3.897 17.86l3.91-3.91 2.829 2.828 4.571-4.57L17 14V9h-5l1.793 1.793-3.157 3.157-2.828-2.829-4.946 4.946A9.965 9.965 0 0 1 2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10a9.987 9.987 0 0 1-8.103-4.14z" />
  //       </g>
  //     </svg>
  //     <ul className="leftbar__menu">
  //       <Link href={"/dashboard"}>
  //         <li>
  //           <svg
  //             xmlns="http://www.w3.org/2000/svg"
  //             width="48"
  //             height="48"
  //             viewBox="0 0 24 24"
  //             fill="none"
  //             stroke="#dddddd"
  //             stroke-width="2"
  //             stroke-linecap="round"
  //             stroke-linejoin="round"
  //             style={{ stroke: "rgb(94, 181, 248);" }}>
  //             <path d="M20 9v11a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V9" />
  //             <path d="M9 22V12h6v10M2 10.6L12 2l10 8.6" />
  //           </svg>
  //         </li>
  //       </Link>
  //       <Link href={"/portfolio"}>
  //         <li>
  //           <svg
  //             xmlns="http://www.w3.org/2000/svg"
  //             width="48"
  //             height="48"
  //             viewBox="0 0 24 24"
  //             fill="none"
  //             stroke="#dddddd"
  //             stroke-width="2"
  //             stroke-linecap="round"
  //             stroke-linejoin="round"
  //             style={{ stroke: "rgb(221, 221, 221);" }}>
  //             <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
  //             <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
  //           </svg>
  //         </li>
  //       </Link>
  //       <Link href={"/watchlist"}>
  //         <li>
  //           <svg
  //             xmlns="http://www.w3.org/2000/svg"
  //             width="48"
  //             height="48"
  //             viewBox="0 0 24 24"
  //             fill="none"
  //             stroke="#dddddd"
  //             stroke-width="2"
  //             stroke-linecap="round"
  //             stroke-linejoin="round"
  //             style={{ stroke: "rgb(221, 221, 221);" }}>
  //             <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
  //           </svg>
  //         </li>
  //       </Link>
  //     </ul>
  //     <h5
  //       class="panel__status"
  //       id="panel__status"
  //       style={{ color: "rgb(235, 88, 135)" }}>
  //       Market status: Closed
  //     </h5>
  //     <svg
  //       xmlns="http://www.w3.org/2000/svg"
  //       className="leftbar__log"
  //       // onClick={() => logout()}
  //       viewBox="0 0 24 24">
  //       <g>
  //         <path fill="none" d="M0 0h24v24H0z" />
  //         <path d="M4 18h2v2h12V4H6v2H4V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3zm2-7h7v2H6v3l-5-4 5-4v3z" />
  //       </g>
  //     </svg>
  //   </aside>
  // );

  //move logo with mouse
  useEffect(() => {
    let box = document.getElementById(".box");
    let boxBoundingRect = box.getBoundingClientRect();
    let boxCenter = {
      x: boxBoundingRect.left + boxBoundingRect.width / 2,
      y: boxBoundingRect.top + boxBoundingRect.height / 2,
    };

    document.addEventListener("mousemove", (e) => {
      let angle =
        Math.atan2(e.pageX - boxCenter.x, -(e.pageY - boxCenter.y)) *
        (180 / Math.PI);
      box.style.transform = `rotate(${angle - 48}deg)`;
    });
  }, []);

  return (
    <aside className="leftbar">
      <motion.svg
        id=".box"
        onClick={() => router.push("/dashboard")}
        className="leftbar__logo"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        whileHover={{ scale: 1.15 }}
        whileTap={{ scale: 0.9, rotate: -90 }}
        transition={{
          type: "spring",
          stiffness: 400,
          damping: 17,
        }}>
        <g>
          <path fill="none" d="M0 0h24v24H0z"></path>
          <path d="M3.897 17.86l3.91-3.91 2.829 2.828 4.571-4.57L17 14V9h-5l1.793 1.793-3.157 3.157-2.828-2.829-4.946 4.946A9.965 9.965 0 0 1 2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10a9.987 9.987 0 0 1-8.103-4.14z"></path>
        </g>
      </motion.svg>

      <motion.ul
        className="leftbar__menu"
        initial={{ opacity: 0, x: -100 }}
        animate={{ opacity: 1, x: 0 }}>
        <Link href={"/dashboard"}>
          <li>
            <motion.svg
              whileHover={{ scale: 1.2 }}
              whileTap={{ scale: 0.9 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              xmlns="http://www.w3.org/2000/svg"
              width="48"
              height="48"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#dddddd"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              style={{
                stroke:
                  page == "dashboard"
                    ? "rgb(36, 180, 126)"
                    : "rgb(221, 221, 221)",
              }}>
              <path d="M20 9v11a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V9"></path>
              <path d="M9 22V12h6v10M2 10.6L12 2l10 8.6"></path>
            </motion.svg>
          </li>
        </Link>
        {/* <Link href={"/trends/topGainers"}>
          <li>
            <motion.svg
              whileHover={{ scale: 1.2 }}
              whileTap={{ scale: 0.9 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
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
              <path d="M12 20v-6M6 20V10M18 20V4"></path>
            </motion.svg>
          </li>
        </Link> */}
        <Link href={"/portfolio"}>
          <li>
            <motion.svg
              whileHover={{ scale: 1.2 }}
              whileTap={{ scale: 0.9 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              xmlns="http://www.w3.org/2000/svg"
              width="48"
              height="48"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#dddddd"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              style={{
                stroke:
                  page == "portfolio"
                    ? "rgb(36, 180, 126)"
                    : "rgb(221, 221, 221)",
              }}>
              <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
              <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
            </motion.svg>
          </li>
        </Link>
        <Link href={"/watchlist"}>
          <li>
            <motion.svg
              whileHover={{ scale: 1.2 }}
              whileTap={{ scale: 0.9 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              xmlns="http://www.w3.org/2000/svg"
              width="48"
              height="48"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#dddddd"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              style={{
                stroke:
                  page == "watchlist"
                    ? "rgb(36, 180, 126)"
                    : "rgb(221, 221, 221)",
              }}>
              <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
            </motion.svg>
          </li>
        </Link>
      </motion.ul>

      <h5
        className="panel__status"
        id="panel__status"
        style={{ color: "rgb(94, 250, 215)" }}>
        Market status: Open
      </h5>

      <motion.svg
        whileHover={{ scale: 1.2 }}
        whileTap={{ scale: 0.9 }}
        transition={{
          type: "spring",
          stiffness: 400,
          damping: 17,
          ease: "linear",
          delay: 0.2,
          duration: 0.2,
        }}
        xmlns="http://www.w3.org/2000/svg"
        className="leftbar__log"
        viewBox="0 0 24 24"
        onClick={() => logout()}
        id="logout">
        <g>
          <path fill="none" d="M0 0h24v24H0z"></path>
          <path d="M4 18h2v2h12V4H6v2H4V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3zm2-7h7v2H6v3l-5-4 5-4v3z"></path>
        </g>
      </motion.svg>
    </aside>
  );
}
