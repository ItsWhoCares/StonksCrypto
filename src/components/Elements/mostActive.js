import { motion } from "framer-motion";
import Link from "next/link";
import { formatCurrency } from "@/helpers";

export default function MostActive({ topCoins }) {
  return (
    <div className="panel__bottom">
      <div className="panel__stockList">
        <ul className="panel__list">
          {/* first three topcoins only*/}
          {topCoins.slice(0, 3).map((coin) => (
            <motion.div
              animate={{ x: 0, opacity: 1 }}
              style={{ width: "100%", x: 200, opacity: 0 }}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              key={coin?.uuid}>
              <li>
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
                          textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                        }}>
                        +{coin.change}%
                      </h5>
                    ) : (
                      <h5
                        style={{
                          color: "rgb(244, 84, 133)",
                          margin: "5px 0px 0px",
                          textShadow: "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                        }}>
                        {coin.change}%
                      </h5>
                    )}
                  </div>
                </Link>
              </li>
            </motion.div>
          ))}
        </ul>
      </div>
      <div className="panel__stockList">
        <ul className="panel__list">
          {topCoins.slice(3, 6).map((coin) => (
            <motion.div
              animate={{ x: 0, opacity: 1 }}
              style={{ width: "100%", x: 200, opacity: 0 }}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              key={coin?.uuid}>
              <li>
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
                          textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                        }}>
                        +{coin.change}%
                      </h5>
                    ) : (
                      <h5
                        style={{
                          color: "rgb(244, 84, 133)",
                          margin: "5px 0px 0px",
                          textShadow: "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                        }}>
                        {coin.change}%
                      </h5>
                    )}
                  </div>
                </Link>
              </li>
            </motion.div>
          ))}
        </ul>
      </div>
      <div className="panel__stockList">
        <ul className="panel__list">
          {topCoins.slice(6, 9).map((coin) => (
            <motion.div
              animate={{ x: 0, opacity: 1 }}
              style={{ width: "100%", x: 200, opacity: 0 }}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              transition={{
                type: "spring",
                stiffness: 400,
                damping: 17,
              }}
              key={coin?.uuid}>
              <li>
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
                          textShadow: "rgba(102, 249, 218, 0.5) 0px 0px 7px",
                        }}>
                        +{coin.change}%
                      </h5>
                    ) : (
                      <h5
                        style={{
                          color: "rgb(244, 84, 133)",
                          margin: "5px 0px 0px",
                          textShadow: "rgba(244, 84, 133, 0.5) 0px 0px 7px",
                        }}>
                        {coin.change}%
                      </h5>
                    )}
                  </div>
                </Link>
              </li>
            </motion.div>
          ))}
        </ul>
      </div>
    </div>
  );
}
