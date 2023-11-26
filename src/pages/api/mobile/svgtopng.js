// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

// const options = {
//   method: "GET",
//   headers: {
//     "X-RapidAPI-Key": "422754484emsh3e47e476be0d92cp12bc35jsn60b5c02b8500",
//     "X-RapidAPI-Host": "coinranking1.p.rapidapi.com",
//   },
// };
import { supabase } from "../../../../Supabase";

const _uploadImage = async (image, filename) => {
  const { data, error } = await supabase.storage
    .from(`coinIcons`)
    .upload(`${filename}`, image, {
      contentType: `image/png`,
    });
  if (error) {
    console.log(error);
    return;
  }
  console.log("Upload done", data);
};

const getImage = async (uri) => {
  let res = await fetch(
    "https://lhizcmwymlozpypgpvia.supabase.co/storage/v1/object/public/coinIcons/" +
      uri
  );
  if (res.status === 400) {
    return null;
  }
  console.log(
    "Image Found",
    "https://lhizcmwymlozpypgpvia.supabase.co/storage/v1/object/public/coinIcons/" +
      uri
  );
  let data = await res.blob();
  //console.log(data);
  return data;
};

export default async function handler(req, res) {
  console.log(req.query);
  const uri = req.query.q;

  const fname = uri
    .substring(uri.lastIndexOf("/") + 1)
    .replace(/[^\w\s\.]/g, "_");

  const img = await getImage(fname);
  if (!img) {
    console.log("Image not found uploading", fname);
    let pre = "https://svg-to-png.mrproper.dev/";
    if (fname.endsWith(".png") || fname.endsWith(".PNG")) {
      pre = "";
      console.log("Image is png");
    }
    let ress = await fetch(pre + uri);
    if (ress.status !== 200) {
      res.status(400).send({ error: "worker error" });
      return;
    }
    let blob = await ress.blob();
    await _uploadImage(blob, fname);
  }

  res.redirect(
    307,
    "https://lhizcmwymlozpypgpvia.supabase.co/storage/v1/object/public/coinIcons/" +
      fname
  );
}
