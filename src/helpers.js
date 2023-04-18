import { useSupabaseClient } from "@supabase/auth-helpers-react";

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
