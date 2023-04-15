import { supabase } from "../../../Supabase";

export default async function SearchCoin(req, res) {
  const { data, error } = await supabase
    .from("Coins")
    .select("*")
    .ilike("Symbol", `%${req.query.symbol}%`)
    .limit(10);
  console.log(req.query.symbol);

  if (error) {
    res.status(500).json({ error: error.message });
  } else {
    res.status(200).json(data);
  }
}
