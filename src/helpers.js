import { useSupabaseClient } from "@supabase/auth-helpers-react";
import dayjs from "dayjs";

export function formatCurrency(amount, notation = "standard", currency = null) {
  let price = new Intl.NumberFormat("en-IN", {
    style: "currency",
    notation: notation,
    currency: currency ?? process.env.NEXT_PUBLIC_REFERENCE_CURRENCY,
    // roundingPriority: amount < 1 ? "morePrecision" : "auto",
    maximumFractionDigits: amount < 1 ? 8 : 2,
  }).format(amount);
  return price;
}

export function formatNumber(amount, notation = "standard") {
  let price = new Intl.NumberFormat("en-IN", {
    style: "decimal",
    notation: notation,
    currency: process.env.NEXT_PUBLIC_REFERENCE_CURRENCY,
  }).format(amount);
  return price;
}

export function formatDateTime(timestamp) {
  return dayjs(timestamp).format("ddd HH:mm");
}

export async function addBookmark(supabase, { userID, coinUUID }) {
  supabase
    .from("bookmarks")
    .insert([{ userID, coinUUID }])
    .then((response) => {
      return response;
    })
    .catch((error) => {
      console.log(error);
    });
}

export async function removeBookmark(supabase, { userID, coinUUID }) {
  console.log(userID, coinUUID);
  supabase
    .from("bookmarks")
    .delete()
    .eq("userID", userID)
    .eq("coinUUID", coinUUID)
    .then((response) => {
      console.log(response);
      return response;
    })
    .catch((error) => {
      console.log(error);
    });
}

export async function getBookmarks(supabase, userID) {
  const { data, error } = await supabase
    .from("bookmarks")
    .select("*")
    .eq("userID", userID);
  if (error) {
    console.log(error);
  }
  //get coin info for each bookmark
  const bookmarks = await Promise.all(
    data.map(async (bookmark) => {
      const res = await fetch(`/api/getCoinInfo?uuid=${bookmark.coinUUID}`);
      const coin = await res.json();
      return {
        ...bookmark,
        price: coin.price,
        symbol: coin.symbol,
        name: coin.name,
        change: coin.change,
      };
    })
  );
  return bookmarks;
}

export async function getBalance(supabase, userID) {
  const { data, error } = await supabase
    .from("user_data")
    .select("*")
    .eq("user_id", userID);
  if (error) {
    console.log(error);
    return -1;
  }
  return data[0]?.balance ?? -1;
}

export async function getPortfolio(supabase, userID) {
  const { data, error } = await supabase
    .from("portfolio")
    .select("*")
    .eq("userID", userID);
  if (error) {
    console.log(error);
    return -1;
  }

  //get coin info for each bookmark
  const portfolio = await Promise.all(
    data.map(async (portfolioItem) => {
      const res = await fetch(
        `/api/getCoinInfo?uuid=${portfolioItem.coinUUID}`
      );
      const coin = await res.json();

      return {
        ...portfolioItem,
        currentPrice: coin.price,
        symbol: coin.symbol,
        name: coin.name,
        change: formatNumber(
          ((coin.price - portfolioItem.coinPrice) / portfolioItem.coinPrice) *
            100
        ),
      };
    })
  );
  return portfolio;
}

export async function createBuyTransaction(
  supabase,
  { userID, coinUUID, coinPrice, quantity }
) {
  const { data, error } = await supabase.from("buy_transaction").insert([
    {
      userID,
      coinUUID,
      coinPrice,
      quantity,
    },
  ]);
  if (error) {
    return { error: true, errorMsg: error.message };
  }
  return { data, error: false };
}

export async function createSellTransaction(supabase, { userID, buyID }) {
  //first get the buy transaction
  const { data, error } = await supabase
    .from("buy_transaction")
    .select("*")
    .eq("id", buyID);
  if (error) {
    return { error: true, errorMsg: error.message };
  }
  const buyTransaction = data[0];
  //get the current price of the coin
  const res = await fetch(`/api/getCoinInfo?uuid=${buyTransaction.coinUUID}`);
  const coin = await res.json();
  const currentPrice = coin.price;
  //create sell transaction
  const { data: data2, error: error2 } = await supabase
    .from("sell_transaction")
    .insert([
      {
        userID,
        buyID,
        coinUUID: buyTransaction.coinUUID,
        coinPrice: currentPrice,
        quantity: buyTransaction.quantity,
      },
    ]);
  if (error2) {
    return { error: true, errorMsg: error2.message };
  }
  return { data: data2, error: false };
}

//   // const { data, error } = await supabase.from("sell_transaction").insert([
//   //   {
//   //     userID,
//   //     coinUUID,
//   //     coinPrice,
//   //     quantity,
//   //   },
//   // ]);
//   // if (error) {
//   //   return { error: true, errorMsg: error.message };
//   // }
//   // return { data, error: false };
// }

export async function getUserNetWorth(supabase, userID) {
  const portfolio = await getPortfolio(supabase, userID);
  const balance = await getBalance(supabase, userID);
  let netWorth = balance;
  portfolio.forEach((item) => {
    netWorth += item.currentPrice * item.quantity;
  });
  return netWorth;
}

export async function getUserAllBuyTransactions(supabase, userID) {
  const { data, error } = await supabase
    .from("buy_transaction")
    .select("*")
    .eq("userID", userID);
  if (error) {
    console.log(error);
    return -1;
  }
  return data;
}

export async function getUserAllSellTransactions(supabase, userID) {
  const { data, error } = await supabase
    .from("sell_transaction")
    .select("*")
    .eq("userID", userID);
  if (error) {
    console.log(error);
    return -1;
  }
  return data;
}

export async function getUserAllTransactions(supabase, userID) {
  const buyTransactions = await getUserAllBuyTransactions(supabase, userID);
  const sellTransactions = await getUserAllSellTransactions(supabase, userID);
  const allTransactions = [...buyTransactions, ...sellTransactions];
  //oreder transactions by created_at
  allTransactions.sort((a, b) => {
    return new Date(b.created_at) - new Date(a.created_at);
  });
  return allTransactions.reverse();
}
